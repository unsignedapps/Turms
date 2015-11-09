//
//  MessageController.swift
//  Turms
//
//  Created by Robert Amos on 6/11/2015.
//  Copyright © 2015 Unsigned Apps. All rights reserved.
//

import UIKit

public class MessageController: NSObject
{
    static let sharedInstance = MessageController()
    
    private let queue: NSOperationQueue
    var delegate: MessageControllerDelegate?
    
    override init()
    {
        self.queue = NSOperationQueue();
        self.queue.maxConcurrentOperationCount = 1;

        super.init();
    }

    public static func show (message: Message)
    {
        let view = MessageView(message: message);
        let op = MessageOperation(view: view);
        self.sharedInstance.queue.addOperation(op);
    }
    
    public static func show (type type: MessageType, message: String)
    {
        self.show(Message(type: type, message: message));
    }
    
    public static func show (type: MessageType, title: String, subtitle: String? = nil, duration: MessageDuration = .Automatic, image: UIImage? = nil, position: MessagePosition = .NavBarOverlay, dismissable: Bool = true)
    {
        self.show(Message(type: type, title: title, subtitle: subtitle, duration: duration, image: image, position: position, dismissable: dismissable));
    }
}

protocol MessageControllerDelegate
{
    func locationOfView (view: MessageView) -> CGFloat
    func customise (view: MessageView)
}


class MessageOperation: NSOperation
{
    private let view: MessageView;
    private var tapGestureRecognizer: UITapGestureRecognizer? = nil
    private var timer: NSTimer? = nil
    
    private var _cancelled: Bool = false
    {
        willSet (value) { self.willChangeValueForKey("isCancelled"); }
        didSet  (value) { self.didChangeValueForKey("isCancelled"); }
        
    }
    override var cancelled: Bool
    {
        get { return self._cancelled; }
    }
    
    private var _executing: Bool = false
    {
        willSet (value) { self.willChangeValueForKey("isExecuting"); }
        didSet  (value) { self.didChangeValueForKey("isExecuting"); }
    }
    override var executing: Bool
    {
        get { return self._executing; }
    }
    
    private var _finished: Bool = false
    {
        willSet (value) { self.willChangeValueForKey("isFinished"); }
        didSet  (value) { self.didChangeValueForKey("isFinished"); }
        
    }
    override var finished: Bool
    {
        get { return self._finished; }
    }
    
    override var concurrent: Bool
    {
        get { return true; }
    }
    
    override var asynchronous: Bool
    {
        get { return true; }
    }
    
    init(view: MessageView)
    {
        self.view = view;
        super.init();
    }
    
    override func start()
    {
        self._executing = true;
        self.show();
    }
    
    func show ()
    {
        // find the current window
        guard let controller = UIApplication.sharedApplication().keyWindow?.rootViewController else { self.cancel(); return; }
        
        // handle cases where we are a nav bar
        dispatch_async(dispatch_get_main_queue())
        {
            self.configureDismissal();
            if let nav = controller as? UINavigationController
            {
                controller.view.insertSubview(self.view, aboveSubview: nav.navigationBar);
            } else
            {
                controller.view.addSubview(self.view);
            }
            controller.view.layoutIfNeeded();                   // The first layout pass is to get the bounds calculated
            
            // align it off screen
            if let constraint = self.view.topConstraint, message = self.view.message
            {
                constraint.constant = CGRectGetHeight(self.view.frame) * -1;
                controller.view.layoutIfNeeded();               // The second is to push the view off screen
                constraint.constant = 0.0;
                
                // and animate in!
                UIView.animateWithDuration(message.animationDuration, animations:
                {
                    controller.view.layoutIfNeeded();           // And then animate back in
                });
            }
        }
    }
    
    private func configureDismissal ()
    {
        guard let message = self.view.message else { return; }
        
        // configure for automatic dismissal
        if message.duration == .Automatic
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: Selector("hide"), userInfo: nil, repeats: false);
        }
        
        // tap to dismiss
        if message.dismissable
        {
            let recognizer = UITapGestureRecognizer(target: self, action: Selector("hide"));
            self.tapGestureRecognizer = recognizer;
            self.view.addGestureRecognizer(recognizer);
        }
    }
    
    override func cancel()
    {
        self._cancelled = true;
        self.hide();
    }
    
    func hide ()
    {
        if let timer = self.timer
        {
            timer.invalidate();
            self.timer = nil;
        }
        
        if let constraint = self.view.topConstraint, message = self.view.message, superview = self.view.superview
        {
            constraint.constant = CGRectGetHeight(self.view.frame) * -1;
            UIView.animateWithDuration(message.animationDuration, delay: 0.0, options: .CurveEaseInOut, animations:
            {
                superview.layoutIfNeeded();

            }, completion:
            {
                completed in
                self.view.removeFromSuperview();
                self.stop();
            });
        } else
        {
            self.view.removeFromSuperview();
            self.stop();
        }
    }
    
    func stop ()
    {
        self._finished = true;
        self._executing = false;
    }
}
//
//  MessageController.swift
//  Turms
//
//  Created by Robert Amos on 6/11/2015.
//  Copyright © 2015 Unsigned Apps. All rights reserved.
//

import UIKit

open class MessageController: NSObject
{
    static let sharedInstance = MessageController()
    
    fileprivate let queue: OperationQueue
    var delegate: MessageControllerDelegate?
    
    override init()
    {
        self.queue = OperationQueue();
        self.queue.maxConcurrentOperationCount = 1;

        super.init();
    }

    open static func show (_ message: Message, controller: UIViewController)
    {
        let view = MessageView(message: message);
        let op = MessageOperation(view: view, controller: controller);
        self.sharedInstance.queue.addOperation(op);
    }
    
    open static func show (type: MessageType, message: String, controller: UIViewController)
    {
        self.show(Message(type: type, message: message), controller: controller);
    }
    
    open static func show (_ type: MessageType, title: String, subtitle: String? = nil, duration: MessageDuration = .automatic, image: UIImage? = nil, position: MessagePosition = .navBarOverlay, dismissible: Bool = true, controller: UIViewController)
    {
        self.show(Message(type: type, title: title, subtitle: subtitle, duration: duration, image: image, position: position, dismissible: dismissible), controller: controller);
    }
}

protocol MessageControllerDelegate
{
    func locationOfView (_ view: MessageView) -> CGFloat
    func customise (_ view: MessageView)
}


class MessageOperation: Operation
{
    fileprivate let view: MessageView;
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer? = nil
    fileprivate var timer: Timer? = nil
    fileprivate let controller: UIViewController
    
    fileprivate var _cancelled: Bool = false
    {
        willSet (value) { self.willChangeValue(forKey: "isCancelled"); }
        didSet  (value) { self.didChangeValue(forKey: "isCancelled"); }
        
    }
    override var isCancelled: Bool
    {
        get { return self._cancelled; }
    }
    
    fileprivate var _executing: Bool = false
    {
        willSet (value) { self.willChangeValue(forKey: "isExecuting"); }
        didSet  (value) { self.didChangeValue(forKey: "isExecuting"); }
    }
    override var isExecuting: Bool
    {
        get { return self._executing; }
    }
    
    fileprivate var _finished: Bool = false
    {
        willSet (value) { self.willChangeValue(forKey: "isFinished"); }
        didSet  (value) { self.didChangeValue(forKey: "isFinished"); }
        
    }
    override var isFinished: Bool
    {
        get { return self._finished; }
    }
    
    override var isConcurrent: Bool
    {
        get { return true; }
    }
    
    override var isAsynchronous: Bool
    {
        get { return true; }
    }
    
    init(view: MessageView, controller: UIViewController)
    {
        self.view = view;
        self.controller = controller;
        super.init();
    }
    
    override func start()
    {
        self._executing = true;
        self.show();
    }
    
    func show ()
    {
        // hang on, are we being dismissed?
        var controller = self.controller;
        if controller.isBeingDismissed {
            controller = controller.presentingViewController ?? controller
        }
        
        // handle cases where we are a nav bar
        DispatchQueue.main.async
        {
            if let nav = controller as? UINavigationController
            {
                controller.view.insertSubview(self.view, aboveSubview: nav.navigationBar);
            } else
            {
                controller.view.addSubview(self.view);
            }
            controller.view.layoutIfNeeded();                   // The first layout pass is to get the bounds calculated
            self.configureDismissal();
            
            // align it off screen
            if let constraint = self.view.topConstraint, let message = self.view.message
            {
                constraint.constant = self.view.frame.height * -1;
                controller.view.layoutIfNeeded();               // The second is to push the view off screen
                constraint.constant = 0.0;
                
                // and animate in!
                UIView.animate(withDuration: message.animationDuration, animations:
                {
                    controller.view.layoutIfNeeded();           // And then animate back in
                });
            }
        }
    }
    
    fileprivate func configureDismissal ()
    {
        guard let message = self.view.message else { return; }
        
        // configure for automatic dismissal
        if message.duration == .automatic
        {
            let displayTime = message.displayTimeBase + (message.displayTimePerPixel * Double(self.view.frame.height));
            self.timer = Timer.scheduledTimer(timeInterval: displayTime, target: self, selector: #selector(MessageOperation.hide), userInfo: nil, repeats: false);
        }
        
        // tap to dismiss
        if message.dismissible
        {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(MessageOperation.hide));
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
        
        if let constraint = self.view.topConstraint, let message = self.view.message, let superview = self.view.superview
        {
            constraint.constant = self.view.frame.height * -1;
            UIView.animate(withDuration: message.animationDuration, delay: 0.0, options: UIViewAnimationOptions(), animations:
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

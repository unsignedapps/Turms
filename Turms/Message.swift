//
//  Message.swift
//  Turms
//
//  Created by Robert Amos on 6/11/2015.
//  Copyright © 2015 Unsigned Apps. All rights reserved.
//

import UIKit

public enum MessageType
{
    case Success
    case Info
    case Warning
    case Error
}

public enum MessagePosition
{
    case Top
    case NavBarOverlay
    case Bottom
}

public enum MessageDuration
{
    case Automatic
    case Endless
}

public struct Message: Equatable
{
    public var type: MessageType
    public var title: String
    public var subtitle: String?
    public var duration: MessageDuration
    public var image: UIImage?
    public var position: MessagePosition
    public var dismissable: Bool
    
    public var animationDuration: NSTimeInterval = 0.34
    public var displayTimeBase: NSTimeInterval = 1.5
    public var displayTimePerPixel: NSTimeInterval = 0.03

    public init (type: MessageType, message: String)
    {
        self.init(type: type, title: message);
    }

    public init (type: MessageType, title: String, subtitle: String? = nil, duration: MessageDuration = .Automatic, image: UIImage? = nil, position: MessagePosition = .NavBarOverlay, dismissable: Bool = true)
    {
        self.type = type;
        self.title = title;
        self.subtitle = subtitle;
        self.duration = duration;
        self.image = image;
        self.position = position;
        self.dismissable = dismissable;
    }

    var backgroundColor: UIColor
    {
        get
        {
            switch (self.type)
            {
                case .Success:
                    return UIColor(red: 118.0/255.0, green: 207.0/255.0, blue: 103.0/255, alpha: 1.0);
                case .Info:
                    return UIColor(red: 103.0/255.0, green: 163.0/255.0, blue: 207.0/255, alpha: 1.0);
                case .Warning:
                    return UIColor(red: 218.0/255.0, green: 196.0/255.0, blue: 60.0/255, alpha: 1.0);
                case .Error:
                    return UIColor(red: 221.0/255.0, green: 59.0/255.0, blue: 65.0/255, alpha: 1.0);
            }
        }
    }
    
    var shadowColor: UIColor
    {
        get
        {
            switch (self.type)
            {
                case .Success:
                    return UIColor(red: 103.0/255.0, green: 183.0/255.0, blue: 89.0/255, alpha: 1.0);
                case .Info:
                    return UIColor(red: 90.0/255.0, green: 145.0/255.0, blue: 184.0/255, alpha: 1.0);
                case .Warning:
                    return UIColor(red: 229.0/255.0, green: 216.0/255.0, blue: 124.0/255, alpha: 1.0);
                case .Error:
                    return UIColor(red: 129.0/255.0, green: 41.0/255.0, blue: 41.0/255, alpha: 1.0);
            }
        }
    }

    var textColor: UIColor
    {
        get
        {
            if self.type == .Warning
            {
                return UIColor(red: 72.0/255.0, green: 70.0/255.0, blue: 56.0/255.0, alpha: 1.0);
            }
            return UIColor.whiteColor();
        }
    }
    
    var titleFontSize: CGFloat
    {
        get { return 14.0; }
    }
    
    var contentFontSize: CGFloat
    {
        get { return 12.0; }
    }
    
    var shadowOffset: CGSize
    {
        get { return CGSizeMake(0.0, -1.0); }
    }
    
    var icon: UIImage?
    {
        get
        {
            if let image = self.image
            {
                return image;
            }
            
            switch (self.type)
            {
                case .Success:
                    return UIImage(named: "MessageSuccessIcon", inBundle: NSBundle(forClass: MessageController.self), compatibleWithTraitCollection: nil)!;
                case .Info:
                    return nil;
                case .Warning:
                    return UIImage(named: "MessageWarningIcon", inBundle: NSBundle(forClass: MessageController.self), compatibleWithTraitCollection: nil)!;
                case .Error:
                    return UIImage(named: "MessageErrorIcon", inBundle: NSBundle(forClass: MessageController.self), compatibleWithTraitCollection: nil)!;
            }
        }
    }
}

public func == (lhs: Message, rhs: Message) -> Bool
{
    return lhs.subtitle == rhs.title && lhs.subtitle == rhs.subtitle;
}




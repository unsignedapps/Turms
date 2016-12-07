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
    case success
    case info
    case warning
    case error
}

public enum MessagePosition
{
    case top
    case navBarOverlay
    case bottom
}

public enum MessageDuration
{
    case automatic
    case endless
}

public struct Message: Equatable
{
    public var type: MessageType
    public var title: String
    public var subtitle: String?
    public var duration: MessageDuration
    public var image: UIImage?
    public var position: MessagePosition
    public var dismissible: Bool
    
    public var animationDuration: TimeInterval = 0.34
    public var displayTimeBase: TimeInterval = 1.5
    public var displayTimePerPixel: TimeInterval = 0.03

    public init (type: MessageType, message: String)
    {
        self.init(type: type, title: message);
    }

    public init (type: MessageType, title: String, subtitle: String? = nil, duration: MessageDuration = .automatic, image: UIImage? = nil, position: MessagePosition = .navBarOverlay, dismissible: Bool = true)
    {
        self.type = type;
        self.title = title;
        self.subtitle = subtitle;
        self.duration = duration;
        self.image = image;
        self.position = position;
        self.dismissible = dismissible;
    }

    var backgroundColor: UIColor
    {
        get
        {
            switch (self.type)
            {
                case .success:
                    return UIColor(red: 118.0/255.0, green: 207.0/255.0, blue: 103.0/255, alpha: 1.0);
                case .info:
                    return UIColor(red: 103.0/255.0, green: 163.0/255.0, blue: 207.0/255, alpha: 1.0);
                case .warning:
                    return UIColor(red: 218.0/255.0, green: 196.0/255.0, blue: 60.0/255, alpha: 1.0);
                case .error:
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
                case .success:
                    return UIColor(red: 103.0/255.0, green: 183.0/255.0, blue: 89.0/255, alpha: 1.0);
                case .info:
                    return UIColor(red: 90.0/255.0, green: 145.0/255.0, blue: 184.0/255, alpha: 1.0);
                case .warning:
                    return UIColor(red: 229.0/255.0, green: 216.0/255.0, blue: 124.0/255, alpha: 1.0);
                case .error:
                    return UIColor(red: 129.0/255.0, green: 41.0/255.0, blue: 41.0/255, alpha: 1.0);
            }
        }
    }

    var textColor: UIColor
    {
        get
        {
            if self.type == .warning
            {
                return UIColor(red: 72.0/255.0, green: 70.0/255.0, blue: 56.0/255.0, alpha: 1.0);
            }
            return UIColor.white;
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
        get { return CGSize(width: 0.0, height: -1.0); }
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
                case .success:
                    return UIImage(named: "MessageSuccessIcon", in: Bundle(for: MessageController.self), compatibleWith: nil)!;
                case .info:
                    return nil;
                case .warning:
                    return UIImage(named: "MessageWarningIcon", in: Bundle(for: MessageController.self), compatibleWith: nil)!;
                case .error:
                    return UIImage(named: "MessageErrorIcon", in: Bundle(for: MessageController.self), compatibleWith: nil)!;
            }
        }
    }
}

public func == (lhs: Message, rhs: Message) -> Bool
{
    return lhs.subtitle == rhs.title && lhs.subtitle == rhs.subtitle;
}




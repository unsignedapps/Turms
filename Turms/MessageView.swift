//
//  MessageView.swift
//  Turms
//
//  Created by Robert Amos on 6/11/2015.
//  Copyright © 2015 Unsigned Apps. All rights reserved.
//

import UIKit

class MessageView: UIView
{
    let message: Message?
    private var stackView: UIView? = nil
    private var backgroundView: UIView? = nil
    
    private var titleLabel: UILabel? = nil
    private var subtitleLabel: UILabel? = nil
    
    private let padding = UIEdgeInsets(top: 35.0, left: 30.0, bottom: 15.0, right: 30.0)
    
    var topConstraint: NSLayoutConstraint? = nil
    
    init (message: Message)
    {
        self.message = message;
        super.init(frame: CGRectZero);
        
        var views: [UIView] = [];
        if let icon = message.icon
        {
            views.append(UIImageView(image: icon));
        }
        
        var messageLabels: [UILabel] = [];
        self.titleLabel = self.titleLabel(message);
        messageLabels.append(self.titleLabel!);
        
        self.subtitleLabel = self.subtitleLabel(message);
        if let label = self.subtitleLabel
        {
            messageLabels.append(label);
        }
        
        let messageStack = self.messageStack(messageLabels);
        views.append(messageStack);
        
        let stack = self.stackView(views);
        let background = self.backgroundView(message);
        
        self.stackView = stack;
        self.backgroundView = background;
        
        self.addSubview(background);
        self.addSubview(stack);
        self.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    override func updateConstraints()
    {
        guard let stack = self.stackView, background = self.backgroundView else { return }
        
        // Ourself
        if let superview = self.superview
        {
            superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["view": self]));
            
            // top constraint
            let constraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1.0, constant: 0.0);
            superview.addConstraint(constraint);
            self.topConstraint = constraint;
        }

        // The Stack
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[view]-right-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: self.padding.metricsDictionary(), views: ["view": stack]));
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[view]-bottom-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: self.padding.metricsDictionary(), views: ["view": stack]));

        // The Background
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["view": background]));
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["view": background]));
        
        // The Title Label
        if let label = self.titleLabel
        {
            label.addConstraint(NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: CGRectGetHeight(label.boundingRectForContents())));
        }
        if let label = self.subtitleLabel
        {
            label.addConstraint(NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: CGRectGetHeight(label.boundingRectForContents())));
        }
        
        super.updateConstraints();
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.message = nil;
        self.stackView = nil;
        self.backgroundView = nil;
        self.titleLabel = nil;
        self.subtitleLabel = nil;
        super.init(coder: aDecoder);
    }
}

// MARK: - UI Components

extension MessageView
{
    private func titleLabel (message: Message) -> UILabel
    {
        let label = UILabel();
        label.text = message.title;
        label.textColor = message.textColor;
        label.numberOfLines = 0;
        label.shadowColor = message.shadowColor;
        label.font = UIFont.boldSystemFontOfSize(message.titleFontSize)
        label.shadowOffset = message.shadowOffset;
        label.textAlignment = .Left;
        return label;
    }
    
    private func subtitleLabel (message: Message) -> UILabel?
    {
        guard let subtitle = message.subtitle else { return nil; }
        
        let label = UILabel();
        label.text = subtitle;
        label.numberOfLines = 0;
        label.textColor = message.textColor;
        label.shadowColor = message.shadowColor;
        label.font = UIFont.systemFontOfSize(message.contentFontSize)
        label.shadowOffset = message.shadowOffset;
        label.textAlignment = .Left;
        return label;
    }
    
    private func messageStack (views: [UIView]) -> UIStackView
    {
        let stack = UIStackView(arrangedSubviews: views);
        stack.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Vertical);
        stack.alignment = .Leading;
        stack.distribution = .Fill;
        stack.axis = .Vertical;
        stack.spacing = 8.0;
        return stack;
    }
    
    private func stackView (views: [UIView]) -> UIStackView
    {
        let stack = UIStackView(arrangedSubviews: views);
        stack.translatesAutoresizingMaskIntoConstraints = false;
        stack.alignment = .Center;
        stack.axis = .Horizontal;
        stack.spacing = 15.0;
        return stack;
    }
    
    private func backgroundView (message: Message) -> UIView
    {
        let background = UIToolbar();
        background.translatesAutoresizingMaskIntoConstraints = false;
        background.barTintColor = message.backgroundColor;
        background.userInteractionEnabled = false;
        background.setBackgroundImage(nil, forToolbarPosition: .Any, barMetrics: .Default);
        return background;
    }
}

extension UIEdgeInsets
{
    func metricsDictionary () -> [String: NSNumber]
    {
        return [
            "top": NSNumber(double: Double(self.top)),
            "bottom": NSNumber(double: Double(self.bottom)),
            "left": NSNumber(double: Double(self.left)),
            "right": NSNumber(double: Double(self.right)),
        ];
    }
}

extension UILabel
{
    func boundingRectForContents () -> CGRect
    {
        if let text = self.text
        {
            let attributes = [ NSFontAttributeName: self.font ];
            return text.boundingRectWithSize(CGSizeMake(CGRectGetWidth(self.frame), 2000), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil);
        }
        
        return CGRectZero;
    }
}

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
    fileprivate var stackView: UIStackView? = nil
    fileprivate var backgroundView: UIView? = nil
    
    fileprivate var titleLabel: UILabel? = nil
    fileprivate var subtitleLabel: UILabel? = nil
    
    fileprivate let padding = UIEdgeInsets(top: 35.0, left: 30.0, bottom: 15.0, right: 30.0)
    
    var topConstraint: NSLayoutConstraint? = nil
    
    init (message: Message)
    {
        self.message = message;
        super.init(frame: CGRect.zero);
        
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
        guard let stack = self.stackView, let background = self.backgroundView else { return }
        
        // Ourself
        if let superview = self.superview
        {
            superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["view": self]));
            
            // top constraint
            let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0);
            superview.addConstraint(constraint);
            self.topConstraint = constraint;
        }

        // The Stack
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[view]-right-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: self.padding.metricsDictionary(), views: ["view": stack]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[view]-bottom-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: self.padding.metricsDictionary(), views: ["view": stack]));

        // The Background
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["view": background]));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["view": background]));
        
        // our expected label width
        let rect = self.frame.isEmpty ? self.superview!.frame : self.frame;
        let width: CGFloat = stack.subviews.count == 1 ? rect.width - self.padding.left - self.padding.right : rect.width - self.padding.left - self.padding.right - stack.spacing - stack.subviews[0].frame.width;
        
        // The Title Label
        if let label = self.titleLabel
        {
            label.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: width));
            label.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: ceil(label.boundingRectForContents(width).height)));
        }
        if let label = self.subtitleLabel
        {
            label.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: width));
            label.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: ceil(label.boundingRectForContents(width).height)));
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
    fileprivate func titleLabel (_ message: Message) -> UILabel
    {
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = message.title;
        label.textColor = message.textColor;
        label.numberOfLines = 0;
        label.shadowColor = message.shadowColor;
        label.font = UIFont.boldSystemFont(ofSize: message.titleFontSize)
        label.shadowOffset = message.shadowOffset;
        label.textAlignment = .left;
        
        // compression resistence
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical);
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal);
        return label;
    }
    
    fileprivate func subtitleLabel (_ message: Message) -> UILabel?
    {
        guard let subtitle = message.subtitle else { return nil; }
        
        let label = UILabel();
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.text = subtitle;
        label.numberOfLines = 0;
        label.textColor = message.textColor;
        label.shadowColor = message.shadowColor;
        label.font = UIFont.systemFont(ofSize: message.contentFontSize)
        label.shadowOffset = message.shadowOffset;
        label.textAlignment = .left;
        
        // compression resistence
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical);
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal);

        return label;
    }
    
    fileprivate func messageStack (_ views: [UIView]) -> UIStackView
    {
        let stack = UIStackView(arrangedSubviews: views);
        stack.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical);
        stack.alignment = .leading;
        stack.distribution = .fill;
        stack.axis = .vertical;
        stack.spacing = 8.0;
        return stack;
    }
    
    fileprivate func stackView (_ views: [UIView]) -> UIStackView
    {
        let stack = UIStackView(arrangedSubviews: views);
        stack.translatesAutoresizingMaskIntoConstraints = false;
        stack.alignment = .center;
        stack.axis = .horizontal;
        stack.spacing = 15.0;
        return stack;
    }
    
    fileprivate func backgroundView (_ message: Message) -> UIView
    {
        let background = UIToolbar();
        background.translatesAutoresizingMaskIntoConstraints = false;
        background.barTintColor = message.backgroundColor;
        background.isUserInteractionEnabled = false;
        background.setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default);
        return background;
    }
}

extension UIEdgeInsets
{
    func metricsDictionary () -> [String: NSNumber]
    {
        return [
            "top": NSNumber(value: Double(self.top) as Double),
            "bottom": NSNumber(value: Double(self.bottom) as Double),
            "left": NSNumber(value: Double(self.left) as Double),
            "right": NSNumber(value: Double(self.right) as Double),
        ];
    }
}

extension UILabel
{
    func boundingRectForContents (_ width: CGFloat) -> CGRect
    {
        if let text = self.text
        {
            let attributes = [ NSFontAttributeName: self.font ];
            return text.boundingRect(with: CGSize(width: width, height: 2000), options: .usesLineFragmentOrigin, attributes: attributes, context: nil);
        }
        
        return CGRect.zero;
    }
}

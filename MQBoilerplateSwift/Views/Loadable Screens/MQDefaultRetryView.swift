//
//  MQRetryView.swift
//  MQBoilerplateSwift
//
//  Created by Matt Quiros on 4/19/15.
//  Copyright (c) 2015 Matt Quiros. All rights reserved.
//

import UIKit

/**
A default implementation of an `MQRetryView`.
*/
open class MQDefaultRetryView: MQRetryView {
    
    open var errorLabel: UILabel
    open var retryButton: UIButton
    var containerView: UIView
    
    open override var error: NSError? {
        didSet {
            if let error = self.error {
                self.errorLabel.text = error.localizedDescription
            } else {
                self.errorLabel.text = nil
            }
            self.setNeedsLayout()
        }
    }
    
    public init() {
        self.errorLabel = UILabel()
        self.retryButton = UIButton(type: .system)
        self.containerView = UIView()
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.white
        self.setupViews()
        self.addAutolayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.errorLabel.numberOfLines = 0
        self.errorLabel.lineBreakMode = .byWordWrapping
        self.errorLabel.textAlignment = .center
        
        self.retryButton.setTitle("Retry", for: UIControlState())
        self.retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        
        self.containerView.addSubviews(self.errorLabel, self.retryButton)
        self.addSubview(containerView)
    }
    
    func addAutolayout() {
        UIView.disableAutoresizingMasksInViews(
            self.errorLabel,
            self.retryButton,
            self.containerView)
        
        self.addAutolayoutInContainerView()
        self.addAutolayoutInMainView()
    }
    
    func addAutolayoutInContainerView() {
        let views = ["errorLabel" : self.errorLabel,
            "retryButton" : self.retryButton] as [String : Any]
        let rules = ["H:|-0-[errorLabel]-0-|",
            "V:|-0-[errorLabel]-0-[retryButton]-0-|"]
        
        self.containerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormatArray(
                rules,
                metrics: nil,
                views: views as [String : AnyObject]))
        
        // Center the Retry button horizontally.
        self.containerView.addConstraint(
            NSLayoutConstraint(item: self.retryButton,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self.containerView,
                attribute: .centerX,
                multiplier: 1,
                constant: 0))
    }
    
    func addAutolayoutInMainView() {
        self.addConstraints([
            NSLayoutConstraint(item: self.containerView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),
            NSLayoutConstraint(item: self.containerView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1,
                constant: 1),
            
            // Limit the container's width to 2/3 of the main view.
            NSLayoutConstraint(item: self.containerView,
                attribute: .width,
                relatedBy: .equal,
                toItem: self,
                attribute: .width,
                multiplier: 2.0 / 3,
                constant: 0)
            ])
    }
    
    func retryButtonTapped() {
        if let delegate = self.delegate {
            delegate.retryViewDidTapRetry(self)
        }
    }
    
}

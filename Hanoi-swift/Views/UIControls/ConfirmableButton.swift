//
//  ConfirmableButton.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class ConfirmableButton: MenuButton {
  
  lazy var targetActionsMap = [NSObject, [AnyObject]]()
  
  var yesButton: BaseButton?
  var noButton: BaseButton?
  var token: dispatch_once_t = 0
  var yesButtonText = "Yes" {
    didSet {
      yesButton?.setTitle(yesButtonText, forState: .Normal)
    }
  }
  var noButtonText = "No" {
    didSet {
      noButton?.setTitle(noButtonText, forState: .Normal)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
    if target != nil && target! === self {
      super.addTarget(target, action: action, forControlEvents: controlEvents)
    } else {
      yesButton?.addTarget(target, action: action, forControlEvents: controlEvents)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    dispatch_once(&token, { [weak self]() -> Void in
      if let strongSelf = self {
        strongSelf.superview?.addSubview(strongSelf.yesButton!)
        strongSelf.superview?.addSubview(strongSelf.noButton!)
        strongSelf.superview?.bringSubviewToFront(strongSelf)
      }
    })
    let frame = self.frame
    let confirmationButtonSize = CGSizeMake((frame.width-CGFloat(UIConstant.buttonsVerticalSpacing))/2.0, frame.height)
    let yesButtonOrigin = frame.origin
    let noButtonOrigin = CGPointMake(frame.origin.x+(frame.width+CGFloat(UIConstant.buttonsVerticalSpacing))/2.0,
      frame.origin.y)
    yesButton?.frame = CGRectMake(yesButtonOrigin.x, yesButtonOrigin.y,
      confirmationButtonSize.width, confirmationButtonSize.height)
    noButton?.frame = CGRectMake(noButtonOrigin.x, noButtonOrigin.y,
      confirmationButtonSize.width, confirmationButtonSize.height)
    applyAppearanceSettingsToButton(yesButton)
    applyAppearanceSettingsToButton(noButton)
  }
  
  private func setup() {
    yesButton = (BaseButton.buttonWithType(.Custom) as! BaseButton)
    noButton = (BaseButton.buttonWithType(.Custom) as! BaseButton)
    yesButton?.setTitle(yesButtonText, forState: .Normal)
    noButton?.setTitle(noButtonText, forState: .Normal)
    yesButton?.layer.opacity = 0
    noButton?.layer.opacity = 0
    self.addTarget(self, action: "presentConfirmation", forControlEvents: .TouchUpInside)
    yesButton?.addTarget(self, action: "yesButtonPressed", forControlEvents: .TouchUpInside)
    noButton?.addTarget(self, action: "dismissConfirmation", forControlEvents: .TouchUpInside)
  }
  
  private func applyAppearanceSettingsToButton(button: UIButton?) {
    button?.layer.cornerRadius = self.layer.cornerRadius
    button?.layer.borderColor = self.layer.borderColor
    button?.layer.borderWidth = self.layer.borderWidth
    button?.backgroundColor = self.backgroundColor
    button?.titleLabel?.font = self.titleLabel?.font
    button?.opaque = self.opaque
    func setAppearanceForState(state: UIControlState) {
      button?.setTitleColor(self.titleColorForState(state), forState: state)
      button?.setTitleShadowColor(self.titleColorForState(state), forState: state)
      button?.setBackgroundImage(self.backgroundImageForState(state), forState: state)
    }
    setAppearanceForState(.Normal)
    setAppearanceForState(.Highlighted)
    setAppearanceForState(.Disabled)
    setAppearanceForState(.Selected)
  }
  
  @objc private func presentConfirmation() {
    self.yesButton?.layer.opacity = 1
    self.noButton?.layer.opacity = 1
    self.layer.opacity = 0
    self.superview?.bringSubviewToFront(yesButton!)
    self.superview?.bringSubviewToFront(noButton!)
  }
  
  @objc private func dismissConfirmation() {
    self.layer.opacity = 1
    yesButton?.layer.opacity = 0
    noButton?.layer.opacity = 0
    self.superview?.bringSubviewToFront(self)
  }
  
  @objc private func yesButtonPressed() {
    dismissConfirmation()
  }
  
}

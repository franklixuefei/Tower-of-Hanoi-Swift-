//
//  ConfirmableButton.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class ConfirmableButton: UIButton {
  
  var yesButton: UIButton?
  var noButton: UIButton?
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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let allActions = allTargetActionsPair()
    // removes all target actions for all events
    self.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
    self.addTarget(self, action: "presentConfirmation", forControlEvents: .TouchUpInside)
    noButton?.addTarget(self, action: "dismissConfirmation", forControlEvents: .TouchUpInside)
    addtargetActionsToYesButton(allActions)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    // TODO: setup YES and NO buttons' appearance according to self
    let frame = self.frame
    let confirmationButtonSize = CGSizeMake(frame.width / 2.0 - 5.0, frame.height)
    let yesButtonOrigin = frame.origin
    let noButtonOrigin = CGPointMake(frame.origin.x + frame.width / 2.0 + 5.0, frame.origin.y)
    yesButton?.frame = CGRectMake(yesButtonOrigin.x, yesButtonOrigin.y,
      confirmationButtonSize.width, confirmationButtonSize.height)
    noButton?.frame = CGRectMake(noButtonOrigin.x, noButtonOrigin.y,
      confirmationButtonSize.width, confirmationButtonSize.height)
    applyAppearanceSettingsToButton(yesButton)
    applyAppearanceSettingsToButton(noButton)
  }
  
  private func setup() {
    yesButton = (UIButton.buttonWithType(.Custom) as! UIButton)
    noButton = (UIButton.buttonWithType(.Custom) as! UIButton)
    yesButton!.setTitle(yesButtonText, forState: .Normal)
    noButton!.setTitle(noButtonText, forState: .Normal)
    yesButton!.layer.opacity = 0
    noButton!.layer.opacity = 0
  }
  
  private func allTargetActionsPair() -> [NSObject:[AnyObject]]? {
    let targets = self.allTargets()
    var targetActionsMap = [NSObject:[AnyObject]]()
    for target in targets {
      let actions = self.actionsForTarget(target, forControlEvent: UIControlEvents.TouchUpInside)
      targetActionsMap[target] = actions
    }
    return targetActionsMap
  }
  
  private func addtargetActionsToYesButton(targetActionsPairs: [NSObject:[AnyObject]]?) {
    if let targetActions = targetActionsPairs {
      for (target, actions) in targetActions {
        for action in actions {
          yesButton?.addTarget(target, action: Selector(action as! String), forControlEvents: .TouchUpInside)
        }
      }
    }
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
    }
    setAppearanceForState(.Normal)
    setAppearanceForState(.Highlighted)
    setAppearanceForState(.Disabled)
    setAppearanceForState(.Selected)
    setAppearanceForState(.Highlighted)
  }
  
  @objc private func presentConfirmation() {
    self.superview!.addSubview(yesButton!)
    self.superview!.addSubview(noButton!)
    UIView.crossFadeViews(viewsToFadeOut: [self], viewsToFadeIn: [yesButton!, noButton!], animationDuration: 0,
      completionBlock:nil)
  }
  
  @objc private func dismissConfirmation() {
    UIView.crossFadeViews(viewsToFadeOut: [yesButton!, noButton!], viewsToFadeIn: [self], animationDuration: 0) {
      [weak self]() -> Void in
      if let strongSelf = self {
        strongSelf.yesButton!.removeFromSuperview()
        strongSelf.noButton!.removeFromSuperview()
      }
      
    }
  }
  
}

//
//  BaseButton.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/25/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    self.opaque = false
    self.backgroundColor = UIColor.color(hexValue: UInt(UIConstant.buttonBackgroundColorForNormalState), alpha: 1)
    self.titleLabel?.font = UIFont.ayuthayaFontWithSize(CGFloat(UIConstant.buttonTitleFontSize))
    self.setTitleColor(UIColor.color(hexValue: UInt(UIConstant.buttonTitleColorForNormalState), alpha: 1),
      forState: .Normal)
    self.setTitleColor(UIColor.color(hexValue: UInt(UIConstant.buttonTitleColorForHighlightedState), alpha: 1),
      forState: .Highlighted)
    self.contentHorizontalAlignment = .Center
    self.contentVerticalAlignment = .Center
    // setup drop shadow
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.applyDropShadow(bezierPathEnabled: false)
  }
  
  override var highlighted: Bool {
    get {
      return super.highlighted
    }
    set {
      if newValue { // highlighted = true
        backgroundColor = UIColor.color(hexValue: UInt(UIConstant.buttonBackgroundColorForHighlightedState), alpha: 1)
      } else {
        backgroundColor = UIColor.color(hexValue: UInt(UIConstant.buttonBackgroundColorForNormalState), alpha: 1)
      }
      super.highlighted = newValue
    }
  }
}

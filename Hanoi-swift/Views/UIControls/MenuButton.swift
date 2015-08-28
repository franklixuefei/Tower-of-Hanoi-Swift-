//
//  MenuButton.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuButton: BaseButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    self.layer.cornerRadius = CGFloat(UIConstant.buttonCornerRadius)
    // set width/height constraints
    self.setTranslatesAutoresizingMaskIntoConstraints(false)
    let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil,
      attribute: .Width, multiplier: 0, constant: CGFloat(UIConstant.buttonWidth))
    // relatively lower priority (default is 1000). If the superview adds some constraints that affect the 
    // button's width, then let them affect.
    widthConstraint.priority = 999
    self.addConstraint(widthConstraint)
    let heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil,
      attribute: .Height, multiplier: 0, constant: CGFloat(UIConstant.buttonHeight))
    self.addConstraint(heightConstraint)
  }

}

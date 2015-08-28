//
//  MenuScrollView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/26/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuScrollView: UIScrollView {
  var contentView = MenuContentView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)
    setup()
  }
  
  private func setup() {
    self.opaque = false
    self.backgroundColor = UIColor.color(hexValue: UInt(UIConstant.menuScrollViewBackgroundColor), alpha: 0.8)
    self.layer.cornerRadius = CGFloat(UIConstant.menuScrollViewCornerRadius)
    self.addSubview(contentView)
    contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
    let views = ["contentView":contentView, "self":self]
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(self)]|", options: nil,
      metrics: nil, views: views))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: nil, metrics: nil,
      views: views))
    self.setTranslatesAutoresizingMaskIntoConstraints(false)
    let heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil,
      attribute: .Height, multiplier: 0, constant: CGFloat(UIConstant.menuScrollViewHeight))
    self.addConstraint(heightConstraint)
  }
  
}

//
//  MenuScrollView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/26/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuScrollView: UIScrollView {
  var verticalDirection: Bool = true
  private var contentView: MenuContentView!
  
  init(verticalDirection: Bool) {
    super.init(frame:CGRectZero)
    self.verticalDirection = verticalDirection
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func addSubview(view: UIView) {
    view.opaque = false
    if view === contentView {
      super.addSubview(view)
      return
    } else {
      contentView.addSubview(view)
    }
  }
  
  private func setup() {
    self.opaque = false
    self.backgroundColor = UIColor.color(hexValue: UInt(UIConstant.menuScrollViewBackgroundColor), alpha: 0.8)
    self.layer.cornerRadius = CGFloat(UIConstant.menuScrollViewCornerRadius)
    contentView = MenuContentView(verticalDirection: verticalDirection)
    self.addSubview(contentView)
    contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
    let views = ["contentView":contentView, "self":self]
    let hFormatString = verticalDirection ? "H:|[contentView(self)]|" : "H:|[contentView]|"
    let vFormatString = verticalDirection ? "V:|[contentView]|" : "V:|[contentView(self)]|"
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hFormatString, options: nil, metrics: nil,
      views: views))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vFormatString, options: nil, metrics: nil,
      views: views))
  }
}

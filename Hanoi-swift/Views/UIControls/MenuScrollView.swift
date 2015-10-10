//
//  MenuScrollView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/26/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuScrollView: UIScrollView {
  lazy var contents = [UIView]()
  
  private var verticalDirection = true
  private var contentView: MenuContentView!
  private var clearAppearance = false
  
  init(verticalDirection: Bool, clearAppearance: Bool = false) {
    super.init(frame:CGRectZero)
    self.verticalDirection = verticalDirection
    self.clearAppearance = clearAppearance
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func addSubview(view: UIView) {
    view.opaque = false
    if view === contentView {
      super.addSubview(view)
    } else {
      contentView.addSubview(view)
      contents.append(view)
    }
  }
  
  private func setup() {
    self.opaque = false
    self.showsHorizontalScrollIndicator = false
    self.showsVerticalScrollIndicator = false
    contentView = MenuContentView(verticalDirection: verticalDirection)
    if !clearAppearance {
      if verticalDirection {
        self.contentInset = UIEdgeInsetsMake(CGFloat(UIConstant.menuScrollViewInset), 0, 0, 0)
      } else {
        self.contentInset = UIEdgeInsetsMake(0, CGFloat(UIConstant.menuScrollViewInset), 0, 0)
      }
      self.backgroundColor = UIColor.color(hexValue: UInt(UIConstant.menuScrollViewBackgroundColor), alpha: 0.8)
      self.layer.cornerRadius = CGFloat(UIConstant.menuScrollViewCornerRadius)
      contentView.viewSpacing = CGFloat(UIConstant.menuScrollViewSpacing)
    }
    self.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    let views = ["contentView":contentView, "self":self]
    let hFormatString = verticalDirection ? "H:|[contentView(self)]|" : "H:|[contentView]|"
    let vFormatString = verticalDirection ? "V:|[contentView]|" : "V:|[contentView(self)]|"
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(hFormatString, options: [], metrics: nil,
      views: views))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(vFormatString, options: [], metrics: nil,
      views: views))
  }
}

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
  
  private var scrollViewInset:CGFloat
  private var scrollViewPadding:CGFloat
  
  private var verticalDirection: Bool
  private var contentView: MenuContentView!
  private var parentScrollView: Bool
  
  init(verticalDirection: Bool, parentScrollView: Bool = true, inset: CGFloat = 0, padding: CGFloat = 0) {
    self.scrollViewInset = inset
    self.scrollViewPadding = padding
    self.verticalDirection = verticalDirection
    self.parentScrollView = parentScrollView
    super.init(frame:CGRectZero)
    setup()
  }
  
  override init(frame: CGRect) {
    self.scrollViewInset = 0
    self.scrollViewPadding = 0
    self.verticalDirection = true
    self.parentScrollView = true
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
    if parentScrollView {
      if verticalDirection {
        self.contentInset = UIEdgeInsetsMake(scrollViewInset, 0, scrollViewInset, 0)
      } else {
        self.contentInset = UIEdgeInsetsMake(0, scrollViewInset, 0, scrollViewInset)
      }
      self.backgroundColor = UIColor.color(hexValue: UInt(UIConstant.menuScrollViewBackgroundColor), alpha: 0.8)
      self.layer.cornerRadius = CGFloat(UIConstant.menuScrollViewCornerRadius)
      contentView.viewSpacing = CGFloat(UIConstant.menuSettingsScrollViewSpacing)
    }
    self.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    if verticalDirection {
      let widthConstraint = NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: self,
        attribute: .Width, multiplier: 1.0, constant: -2.0*scrollViewPadding)
      self.addConstraint(widthConstraint)
      NSLayoutConstraint.pinViewToSuperview(view: contentView, superview: self, paddings: (h:scrollViewPadding, v:0))
    } else {
      let heightConstraint = NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: self,
        attribute: .Height, multiplier: 1.0, constant: -2.0*scrollViewPadding)
      self.addConstraint(heightConstraint)
      NSLayoutConstraint.pinViewToSuperview(view: contentView, superview: self, paddings: (h:0, v:scrollViewPadding))
    }

  }
}

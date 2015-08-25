//
//  ContentView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuContentView: UIView {
  
  var contentViews = [UIView]()
  
  var bottomConstraint: NSLayoutConstraint!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    self.addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil,
      attribute: .Width, multiplier: 0, constant: CGFloat(UIConstant.menuContentViewWidth)))
    bottomConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self,
      attribute: .Bottom, multiplier: 1, constant: 0)
    self.addConstraint(bottomConstraint)
  }
  
  override func addSubview(view: UIView) {
    super.addSubview(view)
    self.removeConstraint(bottomConstraint)
    view.setTranslatesAutoresizingMaskIntoConstraints(false)
    let views = ["view": view]
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: nil, metrics: nil,
      views: views))
    if let lastView = contentViews.last as UIView? {
      // pin view's top to lastView's bottom
      self.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: lastView,
        attribute: .Bottom, multiplier: 1, constant: CGFloat(UIConstant.buttonsVerticalSpacing)))
    } else {
      // pin view's top to self's top
      self.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self,
        attribute: .Top, multiplier: 1, constant: 0))
    }
    bottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self,
      attribute: .Bottom, multiplier: 1, constant: 0)
    self.addConstraint(bottomConstraint)
    contentViews.append(view)
  }

}

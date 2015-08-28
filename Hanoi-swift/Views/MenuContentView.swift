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
  private var innerContentView: UIView!
  
  private var bottomConstraint: NSLayoutConstraint!
  
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
    innerContentView = UIView()
    innerContentView.opaque = false
    self.addSubview(innerContentView)
    innerContentView.setTranslatesAutoresizingMaskIntoConstraints(false)
    let views = ["innerView":innerContentView]
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[innerView]|", options: nil, metrics: nil,
      views: views))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[innerView]|", options: nil, metrics: nil,
      views: views))
    bottomConstraint = NSLayoutConstraint(item: innerContentView, attribute: .Bottom, relatedBy: .GreaterThanOrEqual,
      toItem: innerContentView, attribute: .Top, multiplier: 1, constant: 0)
    innerContentView.addConstraint(bottomConstraint)
  }
  
  override func addSubview(view: UIView) {
    view.opaque = false
    if view === innerContentView {
      super.addSubview(view)
      return
    } else {
      innerContentView.addSubview(view)
    }
    innerContentView.removeConstraint(bottomConstraint)
    view.setTranslatesAutoresizingMaskIntoConstraints(false)
    let views = ["view": view]
    innerContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: nil,
      metrics: nil, views: views))
    if let lastView = contentViews.last as UIView? {
      // pin view's top to lastView's bottom
      innerContentView.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal,
        toItem: lastView, attribute: .Bottom, multiplier: 1, constant: CGFloat(UIConstant.buttonsVerticalSpacing)))
    } else {
      // pin view's top to self's top
      innerContentView.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal,
        toItem: innerContentView, attribute: .Top, multiplier: 1, constant: 0))
    }
    bottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: innerContentView,
      attribute: .Bottom, multiplier: 1, constant: 0)
    innerContentView.addConstraint(bottomConstraint)
    contentViews.append(view)
  }

}

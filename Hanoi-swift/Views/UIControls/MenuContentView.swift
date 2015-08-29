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
  var viewSpacing:CGFloat = 0
  private var innerContentView: UIView!
  private var verticalDirection: Bool = true // verticle by default
  private var bottomConstraint: NSLayoutConstraint!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(verticalDirection: Bool) {
    super.init(frame: CGRectZero)
    self.verticalDirection = verticalDirection
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
    let topOrLeadingAttribute = verticalDirection ? NSLayoutAttribute.Top : NSLayoutAttribute.Leading
    let bottomOrTrailingAttribute = verticalDirection ? NSLayoutAttribute.Bottom : NSLayoutAttribute.Trailing
    bottomConstraint = NSLayoutConstraint(item: innerContentView, attribute: bottomOrTrailingAttribute,
      relatedBy: .GreaterThanOrEqual, toItem: innerContentView, attribute: topOrLeadingAttribute, multiplier: 1,
      constant: 0)
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
    let formatString = verticalDirection ? "H:|[view]|" : "V:|[view]|"
    innerContentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(formatString, options: nil,
      metrics: nil, views: views))
    let topOrLeadingAttribute = verticalDirection ? NSLayoutAttribute.Top : NSLayoutAttribute.Leading
    let bottomOrTrailingAttribute = verticalDirection ? NSLayoutAttribute.Bottom : NSLayoutAttribute.Trailing
    if let lastView = contentViews.last as UIView? {
      // pin view's top to lastView's bottom/trailing
      innerContentView.addConstraint(NSLayoutConstraint(item: view, attribute: topOrLeadingAttribute, relatedBy: .Equal,
        toItem: lastView, attribute: bottomOrTrailingAttribute, multiplier: 1, constant: viewSpacing))
    } else {
      // pin view's top to self's top/leading
      innerContentView.addConstraint(NSLayoutConstraint(item: view, attribute: topOrLeadingAttribute, relatedBy: .Equal,
        toItem: innerContentView, attribute: topOrLeadingAttribute, multiplier: 1, constant: 0))
    }
    bottomConstraint = NSLayoutConstraint(item: view, attribute: bottomOrTrailingAttribute, relatedBy: .Equal,
      toItem: innerContentView, attribute: bottomOrTrailingAttribute, multiplier: 1, constant: 0)
    innerContentView.addConstraint(bottomConstraint)
    contentViews.append(view)
  }

}

//
//  MenuBaseViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/25/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuBaseViewController: UIViewController {
  
  var contentView = MenuContentView()
  
  var contentViewWidthConstraint: NSLayoutConstraint!
  
  override func loadView() {
    let view = UIView()
    self.view = view
    self.view.addSubview(contentView)
    contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
    contentViewWidthConstraint = NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal,
      toItem: nil, attribute: .Width, multiplier: 0, constant: CGFloat(UIConstant.menuContentViewWidthSmall))
    contentView.addConstraint(contentViewWidthConstraint)
    NSLayoutConstraint.centerViewToSuperview(view: contentView, superview: self.view)
  }

}

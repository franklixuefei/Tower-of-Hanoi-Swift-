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
  
  override func loadView() {
    let view = UIView()
    self.view = view
    self.view.addSubview(contentView)
    NSLayoutConstraint.centerViewToSuperview(view: contentView, superview: self.view)
  }

}

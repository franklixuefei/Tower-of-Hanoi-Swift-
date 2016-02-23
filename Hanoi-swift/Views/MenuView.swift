//
//  MenuView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/20/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuView: UIView {

  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.font = UIFont.lucidaFont(size: CGFloat(UIConstant.menuTitleFontSize))
      titleLabel.textColor = UIColor.color(hexValue: UInt(UIConstant.menuTitleColor), alpha: 1.0)
    }
  }
  @IBOutlet weak var menuContainerView: UIView!
  
  func pinViewToContainerView(view: UIView) {
    NSLayoutConstraint.pinViewToSuperview(view: view, superview: menuContainerView)
  }
  
}

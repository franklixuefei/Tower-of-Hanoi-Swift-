//
//  MenuSettingsViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol MenuSettingsViewControllerDelegate: class {
  func backButtonPressed()
}

class MenuSettingsViewController: MenuBaseViewController {

  var backButton: MenuButton!
  var scrollView: MenuScrollView!
  weak var delegate: MenuSettingsViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.contentViewWidthConstraint.constant = CGFloat(UIConstant.menuContentViewWidthLarge)
    scrollView = MenuScrollView()
    scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
    scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Height, relatedBy: .Equal, toItem: nil,
      attribute: .Height, multiplier: 0, constant: CGFloat(UIConstant.menuScrollViewHeightSmall)))
    contentView.addSubview(scrollView)
    backButton = MenuButton.buttonWithType(.Custom) as! MenuButton
    backButton.setTitle("Back", forState: .Normal)
    contentView.addSubview(backButton)
    backButton.addTarget(self, action: "backPressed", forControlEvents: .TouchUpInside)
  }
  
  @objc private func backPressed() {
    delegate?.backButtonPressed()
  }

}

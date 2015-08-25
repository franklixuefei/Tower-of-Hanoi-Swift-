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
  weak var delegate: MenuSettingsViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.widthConstraint.constant = CGFloat(UIConstant.menuContentViewWidthLarge)
    backButton = MenuButton.buttonWithType(.Custom) as! MenuButton
    backButton.setTitle("Back", forState: .Normal)
    contentView.addSubview(backButton)
    backButton.addTarget(self, action: "backPressed", forControlEvents: .TouchUpInside)
  }
  
  @objc private func backPressed() {
    delegate?.backButtonPressed()
  }

}

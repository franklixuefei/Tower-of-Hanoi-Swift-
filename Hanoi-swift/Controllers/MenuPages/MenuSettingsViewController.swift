//
//  MenuSettingsViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol MenuSettingsViewControllerDelegate: class {
  
}

class MenuSettingsViewController: MenuBaseViewController {

  weak var delegate: MenuSettingsViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

}

//
//  MenuResultViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/25/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol MenuResultViewControllerDelegate: class {
  
}

class MenuResultViewController: MenuBaseViewController {

  weak var delegate: MenuResultViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

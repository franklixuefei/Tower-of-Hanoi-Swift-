//
//  MenuPausedViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol MenuPausedViewControllerDelegate: class {
  
}

class MenuPausedViewController: MenuBaseViewController {

  weak var delegate: MenuPausedViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

}

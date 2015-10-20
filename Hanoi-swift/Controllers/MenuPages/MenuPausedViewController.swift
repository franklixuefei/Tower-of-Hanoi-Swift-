//
//  MenuPausedViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol MenuPausedViewControllerDelegate: class {
  func restartButtonPressed()
  func quitButtonPressed()
}

class MenuPausedViewController: MenuBaseViewController {

  var restartButton: ConfirmableButton!
  var quitButton: ConfirmableButton!
  weak var delegate: MenuPausedViewControllerDelegate?
  
  // MARK: - View controller life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    restartButton = ConfirmableButton(type: .Custom) 
    restartButton.setTitle("Restart", forState: .Normal)
    contentView.addSubview(restartButton)
    restartButton.addTarget(self, action: "restartPressed", forControlEvents: .TouchUpInside)
    quitButton = ConfirmableButton(type: .Custom) 
    quitButton.setTitle("Quit", forState: .Normal)
    contentView.addSubview(quitButton)
    quitButton.addTarget(self, action: "quitPressed", forControlEvents: .TouchUpInside)
  }
  
  // MARK: - IBActions
  @objc private func restartPressed() {
    delegate?.restartButtonPressed()
  }
  
  @objc private func quitPressed() {
    delegate?.quitButtonPressed()
  }
}

//
//  MenuInitialViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol MenuInitialViewControllerDelegate: class {
  func startButtonPressed()
  func settingsButtonPressed()
}

class MenuInitialViewController: MenuBaseViewController {

  var startButton: MenuButton!
  var settingsButton: MenuButton!
  weak var delegate: MenuInitialViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startButton = MenuButton(type: .Custom) 
    startButton.setTitle("Start", forState: .Normal)
    contentView.addSubview(startButton)
    startButton.addTarget(self, action: "startPressed", forControlEvents: .TouchUpInside)
    settingsButton = MenuButton(type: .Custom) 
    settingsButton.setTitle("Settings", forState: .Normal)
    contentView.addSubview(settingsButton)
    settingsButton.addTarget(self, action: "settingsPressed", forControlEvents: .TouchUpInside)
  }
  
  @objc private func startPressed() {
    delegate?.startButtonPressed()
  }
  
  @objc private func settingsPressed() {
    delegate?.settingsButtonPressed()
  }

}

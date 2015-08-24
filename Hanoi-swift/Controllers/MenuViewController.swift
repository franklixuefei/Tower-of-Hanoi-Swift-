//
//  ViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, ViewControllerProtocol {
  
  @IBOutlet weak var dotButton: ControlPanelButton!
  
  var dotButtonHidden = false
  lazy var model = GameLogic.defaultModel
  
  override func loadView() {
    let menuView = UIView.viewFromNib(XibNames.MenuViewXibName, owner: self) as! MenuView
    self.view = menuView
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if dotButtonHidden {
      dotButton.hidden = true
    } else {
      dotButton.hidden = false
    }

    for family in UIFont.familyNames()
    {
      println("\(family as! String)")
      for names in UIFont.fontNamesForFamilyName(family as! String)
      {
        println("== \(names as! String)")
      }
    }
  }
  @IBAction func startPressed() {
    model.gameState = .Started
    dotPressed()
  }

  @IBAction func dotPressed() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

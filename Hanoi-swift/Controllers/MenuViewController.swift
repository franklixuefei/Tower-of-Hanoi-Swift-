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
  
  override func loadView() {
    let menuView = UIView.viewFromNib(XibNames.MenuViewXibName, owner: self) as! MenuView
    self.view = menuView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func dotPressed() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}


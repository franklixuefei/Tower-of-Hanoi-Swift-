//
//  ViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, ViewControllerProtocol, MenuInitialViewControllerDelegate,
MenuPausedViewControllerDelegate, MenuSettingsViewControllerDelegate, MenuResultViewControllerDelegate {
  
  @IBOutlet weak var dotButton: BaseButton!
  var menuView: MenuView!
  
  var pageViewController: UIPageViewController!
  
  lazy var model = GameLogic.defaultModel
  lazy var initialMenuPage = MenuInitialViewController()
  lazy var pausedMenuPage = MenuPausedViewController()
  lazy var settingsMenuPage = MenuSettingsViewController()
  lazy var resultMenuPage = MenuResultViewController()
  
  override func loadView() {
    menuView = UIView.viewFromNib(XibNames.MenuViewXibName, owner: self) as! MenuView
    self.view = menuView
    pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal,
      options: nil)
    self.addChildViewController(pageViewController)
    menuView.menuContainerView.addSubview(pageViewController.view)
    menuView.pinViewToContainerView(pageViewController.view)
    self.pageViewController.didMoveToParentViewController(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let gameState = model.gameState
    switch gameState {
    case .Prepared:
      dotButton.hidden = true
      initialMenuPage.delegate = self
      settingsMenuPage.delegate = self
      pageViewController.setViewControllers([initialMenuPage], direction: .Forward, animated: false, completion: nil)
    case .Paused:
      dotButton.hidden = false
      pausedMenuPage.delegate = self
      pageViewController.setViewControllers([pausedMenuPage], direction: .Forward, animated: false, completion: nil)
    case let .Ended(hasWon):
      dotButton.hidden = true
      resultMenuPage.delegate = self
      // TODO: pass the result data to resultMenuPage, e.g., hasWon, time elapsed, steps taken, # disks on dest pole...
      pageViewController.setViewControllers([resultMenuPage], direction: .Forward, animated: false, completion: nil)
    default:
      break
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
//
//    for family in UIFont.familyNames()
//    {
//      println("\(family as! String)")
//      for names in UIFont.fontNamesForFamilyName(family as! String)
//      {
//        println("== \(names as! String)")
//      }
//    }
  }

  @IBAction func dotPressed() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - MenuInitialViewControllerDelegate methods
  
  func startButtonPressed() {
    model.gameState = .Started
    dotPressed()
  }
  
  func settingsButtonPressed() {
    pageViewController.setViewControllers([settingsMenuPage], direction: .Forward, animated: true, completion: nil)
  }
  
  // MARK: - MenuPausedViewControllerDelegate methods
  
  // MARK: - MenuSettingsViewControllerDelegate methods
  
  // MARK: - MenuResultViewControllerDelegate methods
  
  
}

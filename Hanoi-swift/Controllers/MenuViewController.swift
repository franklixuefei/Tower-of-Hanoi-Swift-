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
    registerObserverForModel(notificationName: InfrastructureConstant.gameStateNotificationChannelName) {
      (this) -> Void in
      switch this.model.gameState {
      case .Prepared:
        this.prepareGame()
      case .Started:
        this.startGame()
      case .Paused:
        this.pauseGame()
      case .Resumed:
        this.resumeGame()
      case let .Ended(hasWon):
        this.endGame(hasWon)
      default:
        break
      }
    }
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    let gameState = model.gameState
    switch gameState {
    case .Prepared:
      prepareGame()
      initialMenuPage.delegate = self
      settingsMenuPage.delegate = self
      pageViewController.setViewControllers([initialMenuPage], direction: .Forward, animated: false, completion: nil)
    case .Paused:
      pauseGame()
      pausedMenuPage.delegate = self
      pageViewController.setViewControllers([pausedMenuPage], direction: .Forward, animated: false, completion: nil)
    case let .Ended(hasWon):
      endGame(hasWon)
      resultMenuPage.delegate = self
      // TODO: let the model to evaluate the result data, and then pass the result data to resultMenuPage, 
      // e.g., hasWon, time elapsed, steps taken, # disks on dest pole...
      // and then maybe save the evaluated data to NSUserDefault
      pageViewController.setViewControllers([resultMenuPage], direction: .Forward, animated: false, completion: nil)
    default:
      break
    }
  }
  
  private func registerObserverForModel(#notificationName: String!, block: (MenuViewController) -> Void) {
    NotificationManager.defaultManager.registerObserver(notificationName, forObject: model) {
      [weak self](notification) -> Void in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if let strongSelf = self {
          block(strongSelf)
        }
      })
    }
  }
  
  private func prepareGame() {
    menuView.titleLabel.text = LogicConstant.gameTitle
    dotButton.hidden = true
  }
  
  private func startGame() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  private func pauseGame() {
    menuView.titleLabel.text = LogicConstant.pausedTitle
    dotButton.hidden = false
  }
  
  private func resumeGame() {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  private func endGame(hasWon: Bool) {
    if hasWon {
      menuView.titleLabel.text = LogicConstant.winTitle
    } else {
      menuView.titleLabel.text = LogicConstant.loseTitle
    }
    dotButton.hidden = true
  }

  @IBAction func dotPressed() {
    model.gameState = .Resumed
  }
  
  // MARK: - MenuInitialViewControllerDelegate methods
  
  func startButtonPressed() {
    model.gameState = .Started
  }
  
  func settingsButtonPressed() {
    pageViewController.setViewControllers([settingsMenuPage], direction: .Forward, animated: true, completion: nil)
  }
  
  // MARK: - MenuPausedViewControllerDelegate methods
  
  func backButtonPressed() {
    pageViewController.setViewControllers([initialMenuPage], direction: .Reverse, animated: true, completion: nil)
  }
  
  // MARK: - MenuSettingsViewControllerDelegate methods
  
  func restartButtonPressed() {
    model.gameState = .Started
  }
  
  func quitButtonPressed() {
    pageViewController.setViewControllers([initialMenuPage], direction: .Reverse, animated: true, completion: nil)
    model.gameState = .Prepared
  }
  
  // MARK: - MenuResultViewControllerDelegate methods
  
  
}

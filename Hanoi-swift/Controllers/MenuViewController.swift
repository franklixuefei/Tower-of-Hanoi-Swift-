//
//  ViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, MenuInitialViewControllerDelegate,
MenuPausedViewControllerDelegate, MenuSettingsViewControllerDelegate, MenuResultViewControllerDelegate {
  
  @IBOutlet weak var dotButton: BaseButton!
  var menuView: MenuView!
  
  var pageViewController: UIPageViewController!
  lazy var initialMenuPage:MenuInitialViewController = MenuInitialViewController()
  lazy var pausedMenuPage:MenuPausedViewController = MenuPausedViewController()
  lazy var settingsMenuPage:MenuSettingsViewController = MenuSettingsViewController()
  lazy var resultMenuPage:MenuResultViewController = MenuResultViewController()
  
  lazy var model = GameLogic.defaultModel
  
  // MARK: - View controller life cycle
  override func loadView() {
    menuView = UIView.viewFromNib(XibNames.MenuViewXibName, owner: self) as! MenuView
    self.view = menuView
    pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal,
      options: nil)
    self.addChildViewController(pageViewController)
    menuView.menuContainerView.addSubview(pageViewController.view)
    menuView.pinViewToContainerView(pageViewController.view)
    self.pageViewController.didMoveToParentViewController(self)
    
    // add gesture recognizer to MenuView
    let dismissGesture = UITapGestureRecognizer(target: self, action: "dotPressed")
    menuView.addGestureRecognizer(dismissGesture)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // registers game state listener
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
      // TODO: maybe save the evaluated data to NSUserDefault
      resultMenuPage.hasWon = hasWon
      resultMenuPage.timeElapsedInSeconds = model.timer.timeElapsedInSeconds
      resultMenuPage.stepsTaken = model.counter
      resultMenuPage.level = model.gameLevel
      resultMenuPage.numDisksOnDest = model.calculateNumDisksMovedOver()
      pageViewController.setViewControllers([resultMenuPage], direction: .Forward, animated: false, completion: nil)
    default:
      break
    }
  }
  
  // MARK: - Game life cycle
  private func prepareGame() {
    menuView.titleLabel.text = LogicConstant.gameTitle
    dotButton.hidden = true
  }
  
  private func startGame() {
    self.dismissViewControllerAnimated(true, completion: nil)
    if model.previousGameState == .Paused {
      dotButton.hidden = false
    } else if model.previousGameState == .Prepared {
      dotButton.hidden = true
    }
  }
  
  private func pauseGame() {
    menuView.titleLabel.text = LogicConstant.pausedTitle
    dotButton.hidden = false
  }
  
  private func resumeGame() {
    self.dismissViewControllerAnimated(true, completion: nil)
    dotButton.hidden = false
  }
  
  private func endGame(hasWon: Bool) {
    if hasWon {
      menuView.titleLabel.text = LogicConstant.winTitle
    } else {
      menuView.titleLabel.text = LogicConstant.loseTitle
    }
    dotButton.hidden = true
  }

  // MARK: - MenuInitialViewControllerDelegate methods
  func startButtonPressed() {
    model.gameState = .Started
  }
  
  func settingsButtonPressed() {
    pageViewController.setViewControllers([settingsMenuPage], direction: .Forward, animated: true, completion: nil)
  }
  
  // MARK: - MenuSettingsViewControllerDelegate methods
  func backButtonPressed() {
    pageViewController.setViewControllers([initialMenuPage], direction: .Reverse, animated: true, completion: nil)
  }
  
  func modeSelected(mode: String) {
    switch mode {
    case LogicConstant.casualModeString:
      model.gameMode = .Casual
    case LogicConstant.challengeModeString:
      model.gameMode = .Challenge
    default:
      break
    }
  }
  
  func currentGameLevel() -> Int {
    return model.gameLevel
  }
  
  func gameLevelSliderChanged(level: Int) {
    model.gameLevel = level
  }
 
  // MARK: - MenuPausedViewControllerDelegate methods
  func restartButtonPressed() {
    model.gameState = .Started
  }
  
  func quitButtonPressed() {
    pageViewController.setViewControllers([initialMenuPage], direction: .Reverse, animated: true, completion: nil)
    model.gameState = .Prepared
  }
  
  // MARK: - MenuResultViewControllerDelegate methods
  func okButtonPressed(nextLevel: Int) {
    pageViewController.setViewControllers([initialMenuPage], direction: .Reverse, animated: true, completion: nil)
    model.gameState = .Prepared
    if nextLevel != model.gameLevel {
      model.gameLevel = nextLevel
    }
  }
  
  // MARK: - Helpers
  private func registerObserverForModel(notificationName notificationName: String!, block: (MenuViewController) -> Void) {
    NotificationManager.defaultManager.registerObserver(notificationName, forObject: model) {
      [weak self](notification) -> Void in
      Utility.dispatchToMainThread { () -> Void in
        if let strongSelf = self {
          block(strongSelf)
        }
      }
    }
  }
  
  // MARK: - IBActions
  @IBAction func dotPressed() {
    if model.gameState == .Prepared { // Do not dismiss the menu page in the initial game state!
      return
    }
    if model.gameState == .Paused {
      model.gameState = .Resumed
    }
    self.pausedMenuPage.restartButton.dismissConfirmation()
    self.pausedMenuPage.quitButton.dismissConfirmation()
  }
  
}

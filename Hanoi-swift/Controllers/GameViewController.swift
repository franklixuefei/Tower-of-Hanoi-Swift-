//
//  GameViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIViewControllerTransitioningDelegate,
ViewControllerProtocol, DiskViewDelegate {

  @IBOutlet weak var dotButton: ControlPanelButton!
  
  var menuViewController: MenuViewController?
  lazy var model = GameLogic.defaultModel
  var gameSceneView: GameSceneView!
  var controlPanelView: ControlPanelView!
  lazy var diskViewToDiskMap = [DiskView:Disk]()
  
  var controlPanelHorizontalPositionConstraint: NSLayoutConstraint!
  
  private func setupControlPanel() {
    controlPanelView = UIView.viewFromNib(XibNames.ControlPanelViewXibName, owner: self) as! ControlPanelView
    self.view.addSubview(controlPanelView);
    controlPanelView.setTranslatesAutoresizingMaskIntoConstraints(false)
    let views = ["controlPanel": controlPanelView]
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[controlPanel]|", options: nil, metrics: nil, views: views))
    let heightConstraint = NSLayoutConstraint(item: controlPanelView, attribute: .Height, relatedBy: .Equal,
      toItem: nil, attribute: .Height, multiplier: 0, constant: CGFloat(UIConstant.controlPanelHeight))
    controlPanelView.addConstraint(heightConstraint)
    controlPanelHorizontalPositionConstraint = NSLayoutConstraint(item: controlPanelView, attribute: .Top,
      relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1,
      constant: CGFloat(-UIConstant.controlPanelHeight))
    self.view.addConstraint(controlPanelHorizontalPositionConstraint)
  }
  
  private func setupControlPanelDropShadow() {
    let shadowPath = UIBezierPath(rect: controlPanelView.bounds)
    controlPanelView.layer.masksToBounds = false
    controlPanelView.layer.shadowColor = UIColor.blackColor().CGColor
    controlPanelView.layer.shadowOffset = CGSizeMake(0, 1)
    controlPanelView.layer.shadowOpacity = 0.3
    controlPanelView.layer.shadowPath = shadowPath.CGPath
    controlPanelView.layer.shadowRadius = 1.5
  }
  
  override func loadView() {
    // setup game scene
    gameSceneView = UIView.viewFromNib(XibNames.GameSceneViewXibName, owner: self) as! GameSceneView
    self.view = gameSceneView
    setupControlPanel()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerObserverForModel(notificationName: InfrastructureConstant.gameStateNotificationChannelName) {
      (this) -> Void in
      println("game state changed to: \(this.model.gameState.description())")
      switch this.model.gameState {
      case .Prepared:
        this.prepareGame()
      case .Started:
        this.startGame()
      case .Paused:
        this.pauseGame()
      case let .Ended(hasWon):
        this.endGame(hasWon)
      }
    }
    registerObserverForModel(notificationName: InfrastructureConstant.gameModeNotificationChannelName) {
      (this) -> Void in
      println("game mode changed to: \(this.model.gameMode.description())")
    }
    registerObserverForModel(notificationName: InfrastructureConstant.gameLevelNotificationChannelName) {
      (this) -> Void in
      println("game level changed to: \(this.model.gameLevel)")
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Force layout immediately in order to get the views' actual frame after constraints being applied
    gameSceneView.setNeedsLayout()
    gameSceneView.layoutIfNeeded()
    setupControlPanelDropShadow()
    let diskViews = createDisks()
    for diskView in diskViews {
      placeDisk(diskView, onPole: .OriginalPole, animated: false)
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    showMenu(hideDotButton: true)
  }
  
  private func registerObserverForModel(#notificationName: String!, block: (GameViewController) -> Void) {
    NotificationManager.defaultManager.registerObserver(notificationName, forObject: model) {
      [weak self](notification) -> Void in
      if let strongSelf = self {
        block(strongSelf)
      }
    }
  }
  
  @IBAction func dotPressed() {
    showMenu()
  }
  
  private func showMenu(hideDotButton hide: Bool = false) {
    if menuViewController == nil {
      menuViewController = MenuViewController()
      menuViewController!.view.frame = self.view.bounds
      menuViewController!.transitioningDelegate = self
      menuViewController!.modalPresentationStyle = .Custom
    }
    if hide {
      menuViewController!.dotButtonHidden = true
    } else {
      menuViewController!.dotButtonHidden = false
    }
    self.presentViewController(menuViewController!, animated: true, completion: nil)
  }
  
  func createDisks() -> [DiskView] {
    let numberOfDisks = 5; // TODO: from GameLogic
    let poleBaseWidth = gameSceneView.originalPole.poleBaseWidth
    let poleStickHeight = gameSceneView.originalPole.poleStickHeight
    let disks = model.createDisks(largestDiskWidth: Double(poleBaseWidth) - DiskConstant.diskWidthOffset,
      numberOfDisks: numberOfDisks, maximumDiskPileHeight: Double(poleStickHeight))
    var diskViews = [DiskView]()
    for disk in disks {
      let diskView = createDisk(disk: disk)
      diskViews.append(diskView)
      diskViewToDiskMap[diskView] = disk
      diskView.delegate = self
    }
    return diskViews
  }
  
  private func createDisk(#disk: Disk) -> DiskView {
    let diskView = UIView.viewFromNib(XibNames.DiskViewXibName) as! DiskView
    let diskWidth = CGFloat(disk.width)
    let diskHeight = CGFloat(Disk.height)
    gameSceneView.addSubview(diskView)
    diskView.frame = CGRectMake(0, 0, diskWidth, diskHeight)
    return diskView
  }
  
  func placeDisk(diskView: DiskView, onPole type: PoleType, animated: Bool) {
    if let disk = diskViewToDiskMap[diskView] {
      let pole = gameSceneView.poleViewForPoleType(type)
      if let removedDisk = model.removeDisk(disk) { // TODO: delete assertion in production
        assert(removedDisk === disk, "removed disk should be disk")
      }
      let poleBaseFrame = pole.convertRect(pole.poleBase.frame, toView: gameSceneView)
      let poleStickCenter = pole.convertPoint(pole.poleStick.center, toView: gameSceneView)
      let poleStickCenterX = poleStickCenter.x
      let diskCenterX = poleStickCenterX
      let diskCenterY = poleBaseFrame.origin.y -
        CGFloat(model.pileHeight(poleType: type) + 0.5*Disk.height)
      UIView.animateWithDuration(animated ? 0.3 : 0, animations: { () -> Void in
        diskView.center = CGPointMake(diskCenterX, diskCenterY)
      })
      model.placeDisk(disk, onPole: type)
    }
  }
  
  func prepareGame() {
    
  }
  
  func startGame() {
    dispatch_async(dispatch_get_main_queue(), { [weak self]() -> Void in
      if let strongSelf = self {
        strongSelf.view.layoutIfNeeded()
        strongSelf.controlPanelHorizontalPositionConstraint.constant = CGFloat(-0.5*UIConstant.controlPanelHeight)
        UIView.animateWithDuration(0.4, delay: UIConstant.rippleAnimatorTransitionDuration,
          usingSpringWithDamping: 0.45, initialSpringVelocity: 1,
          options: nil, animations: { [weak strongSelf]() -> Void in
            if let this = strongSelf {
              this.view.layoutIfNeeded()
            }}, completion: nil)
      }
    })
  }
  
  func resetGame() {
    prepareGame()
    startGame()
  }
  
  func pauseGame() {
    
  }
  
  func endGame(hasWon: Bool) {
    
  }
  
  private func poleTypeForPoint(point: CGPoint) -> PoleType? {
    if CGRectContainsPoint(gameSceneView.originalPole.frame, point) {
      return .OriginalPole
    } else if CGRectContainsPoint(gameSceneView.bufferPole.frame, point) {
      return .BufferPole
    } else if CGRectContainsPoint(gameSceneView.destinationPole.frame, point) {
      return .DestinationPole
    }
    return nil
  }
  
  // MARK: UIViewControllerTransitioningDelegate methods
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController
    presenting: UIViewController, sourceController source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
    RippleTransitionAnimator.defaultAnimator.presenting = true
    return RippleTransitionAnimator.defaultAnimator
  }
  
  func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
    return nil
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
    RippleTransitionAnimator.defaultAnimator.presenting = false
    return RippleTransitionAnimator.defaultAnimator
  }
  
  
  func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
    return nil
  }
  
  // MARK: DiskViewDelegate methods
  
  func gestureState(state: UIGestureRecognizerState, onDisk diskView: DiskView) {
    if let disk = diskViewToDiskMap[diskView] {
      switch state {
      case .Ended:
        // put the disk to the right pole according to its current location and size
        if let poleType = poleTypeForPoint(diskView.center) {
          if model.shouldDiskPlaceToPole(disk: disk, pole: poleType) {
            placeDisk(diskView, onPole: poleType, animated: true)
          } else {
            fallthrough
          }
        } else {
          fallthrough
        }
      case .Failed, .Cancelled:
        // revert disk to original place
        placeDisk(diskView, onPole: disk.onPole!, animated: true)
      default:
        break
      }
    }
  }
  
  func shouldBeginRecognizingGestureForDisk(diskView: DiskView) -> Bool {
    if let disk = diskViewToDiskMap[diskView] {
      return model.shouldDiskMove(disk)
    } else {
      return false
    }
  }
}

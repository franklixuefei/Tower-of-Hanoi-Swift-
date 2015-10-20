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

  @IBOutlet weak var dotButton: BaseButton!
  
  var menuViewController: MenuViewController?
  lazy var model = GameLogic.defaultModel
  var gameSceneView: GameSceneView!
  var controlPanelView: ControlPanelView!
  lazy var diskViewToDiskMap = [DiskView:Disk]()
  lazy var diskViewsForPole = [PoleType:[DiskView]]() // the last element in each array is the top diskview
  
  var intervalPoller: NSTimer?
  var timer = Timer()
  var timerCountUp = true
  
  var counter = 0
  
  var replayMode = false // true when replaying the game or program solving the game
  
  var controlPanelHorizontalPositionConstraint: NSLayoutConstraint!
  
  private func setupControlPanel() {
    controlPanelView = UIView.viewFromNib(XibNames.ControlPanelViewXibName, owner: self) as! ControlPanelView
    self.view.addSubview(controlPanelView);
    controlPanelView.translatesAutoresizingMaskIntoConstraints = false
    let views = ["controlPanel": controlPanelView]
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[controlPanel]|", options: [], metrics: nil, views: views))
    let heightConstraint = NSLayoutConstraint(item: controlPanelView, attribute: .Height, relatedBy: .Equal,
      toItem: nil, attribute: .Height, multiplier: 0, constant: CGFloat(UIConstant.controlPanelHeight))
    controlPanelView.addConstraint(heightConstraint)
    controlPanelHorizontalPositionConstraint = NSLayoutConstraint(item: controlPanelView, attribute: .Top,
      relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1,
      constant: CGFloat(-UIConstant.controlPanelHeight))
    self.view.addConstraint(controlPanelHorizontalPositionConstraint)
    
    // setup game solver control
    let doubleTap = UITapGestureRecognizer(target: self, action: "timerLabelTapped")
    doubleTap.numberOfTapsRequired = 2
    controlPanelView.timerLabel.userInteractionEnabled = true
    controlPanelView.timerLabel.addGestureRecognizer(doubleTap)
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
      print("game state changed to: \(this.model.gameState.description)")
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
    registerObserverForModel(notificationName: InfrastructureConstant.gameModeNotificationChannelName) {
      (this) -> Void in
      print("game mode changed to: \(this.model.gameMode.description)")
      switch this.model.gameMode {
      case .Casual:
        this.timerCountUp = true
      case .Challenge:
        this.timerCountUp = false
      }
    }
    registerObserverForModel(notificationName: InfrastructureConstant.gameLevelNotificationChannelName) {
      (this) -> Void in
      print("game level changed to: \(this.model.gameLevel)")
      this.model.gameState = .Prepared
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Force layout immediately in order to get the views' actual frame after constraints being applied
    gameSceneView.setNeedsLayout()
    gameSceneView.layoutIfNeeded()
    controlPanelView.applyDropShadow()
    model.gameState = .Prepared
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    showMenu()
  }
  
  private func registerObserverForModel(notificationName notificationName: String!, block: (GameViewController) -> Void) {
    NotificationManager.defaultManager.registerObserver(notificationName, forObject: model) {
      [weak self](notification) -> Void in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if let strongSelf = self {
          block(strongSelf)
        }
      })
    }
  }
  
  @IBAction func dotPressed() {
    model.gameState = .Paused
  }
  
  private func showMenu() {
    if menuViewController == nil {
      menuViewController = MenuViewController()
      menuViewController!.view.frame = self.view.bounds
      menuViewController!.transitioningDelegate = self
      menuViewController!.modalPresentationStyle = .Custom
    }
    self.presentViewController(menuViewController!, animated: true, completion: nil)
  }
  
  func initiateDisks() {
    let diskViews = createDisks()
    for diskView in diskViews {
      placeDisk(diskView, onPole: .OriginalPole, animated: false)
    }
  }
  
  func createDisks() -> [DiskView] {
    let numberOfDisks = model.gameLevel
    let poleBaseWidth = gameSceneView.originalPole.poleBaseWidth
    let poleStickHeight = gameSceneView.originalPole.poleStickHeight
    let disks = model.createDisks(largestDiskWidth: Double(poleBaseWidth) - UIConstant.diskWidthOffset,
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
  
  private func createDisk(disk disk: Disk) -> DiskView {
    let diskView = UIView.viewFromNib(XibNames.DiskViewXibName) as! DiskView
    let diskWidth = CGFloat(disk.width)
    let diskHeight = CGFloat(Disk.height)
    gameSceneView.addSubview(diskView)
    diskView.frame = CGRectMake(0, 0, diskWidth, diskHeight)
    return diskView
  }
  
  func moveDisk(diskView: DiskView, toPole type: PoleType, animated: Bool) {
    if let disk = diskViewToDiskMap[diskView] {
      let fromPole = gameSceneView.poleViewForPoleType(disk.onPole!)
      let toPole = gameSceneView.poleViewForPoleType(type)
      
      let poleBaseFrame = fromPole.convertRect(fromPole.poleBase.frame, toView: gameSceneView)
      var poleStickCenter = fromPole.convertPoint(fromPole.poleStick.center, toView: gameSceneView)
      var poleStickCenterX = poleStickCenter.x
      var diskCenterX = poleStickCenterX
      let diskCenterY = poleBaseFrame.origin.y - (fromPole.poleStickHeight + CGFloat(0.5*Disk.height))
      
      UIView.animateWithDuration(animated ? 0.3 : 0, delay: 0, options: .CurveEaseIn,
        animations: { () -> Void in
          diskView.center = CGPointMake(diskCenterX, diskCenterY)
        }, completion: nil
      )
      
      poleStickCenter = toPole.convertPoint(toPole.poleStick.center, toView: gameSceneView)
      poleStickCenterX = poleStickCenter.x
      diskCenterX = poleStickCenterX
      
      UIView.animateWithDuration(animated ? 0.3 : 0, delay: animated ? 0.3 : 0, options: .CurveLinear,
        animations: { () -> Void in
          diskView.center = CGPointMake(diskCenterX, diskCenterY)
        }, completion: nil
      )
    }
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
      let diskCenterY = poleBaseFrame.origin.y - CGFloat(model.pileHeight(poleType: type) + 0.5*Disk.height)
      UIView.animateWithDuration(animated ? 0.3 : 0, delay: 0, options: .CurveEaseOut,
        animations: { () -> Void in
          diskView.center = CGPointMake(diskCenterX, diskCenterY)
        },
        completion: { [weak self](completed) -> Void in
          if let strongSelf = self {
            // check game won after placing the disk
            strongSelf.model.hasWon()
          }
        }
      )
      if let fromPole = disk.onPole {
        diskViewsForPole[fromPole]?.removeLast()
      }
      model.placeDisk(disk, onPole: type, replayMode: replayMode)
      if diskViewsForPole[type] == nil {
        diskViewsForPole[type] = [DiskView]()
      }
      diskViewsForPole[type]?.append(diskView)
      print("originalPoleDiskViewsCount: \(diskViewsForPole[.OriginalPole]?.count)")
      print("bufferPoleDiskViewsCount: \(diskViewsForPole[.BufferPole]?.count)")
      print("destinationPoleDiskViewsCount: \(diskViewsForPole[.DestinationPole]?.count)")
    }
  }
  
  func clearDisks() {
    let diskViews = diskViewToDiskMap.keys.elements
    for diskView in diskViews {
      diskView.removeFromSuperview()
    }
    diskViewToDiskMap.removeAll(keepCapacity: false)
    diskViewsForPole.removeAll()
    print("diskViewToDiskMap count: \(diskViewToDiskMap.count)")
    model.clearDisks()
  }
  
  // MARK: Game Lifecycle
  
  // gameState has changed to .Prepared
  private func prepareGame() {
    if model.previousGameState != .Empty && model.previousGameState != .Prepared {
      hideControlPanel()
      resetTimer()
      resetCounter()
    }
    if model.previousGameState != .Empty {
      clearDisks()
    }
    initiateDisks()
    controlPanelView.level = model.gameLevel
  }
  
  // gameState has changed to .Started
  private func startGame() {
    if model.previousGameState == .Prepared {
      showControlPanel()
    } else if model.previousGameState == .Paused { // restarted
      resetTimer()
      resetCounter()
      clearDisks()
      initiateDisks()
    }
    startTimer()
  }
  
  // gameState has changed to .Paused
  private func pauseGame() {
    pauseTimer()
    showMenu()
  }
  
  // gameState has changed to .Resumed
  private func resumeGame() {
    resumeTimer()
  }
  
  // gameState has changed to let .Ended(hasWon)
  private func endGame(hasWon: Bool) {
    pauseTimer()
    showMenu()
  }
  
  private func showControlPanel() {
    let damping = CGFloat(UIConstant.animationSpringWithDamping)
    let velocity = CGFloat(UIConstant.animationSpringVelocity)
    let delay = UIConstant.rippleAnimatorTransitionDuration
    self.view.layoutIfNeeded()
    self.controlPanelHorizontalPositionConstraint.constant = CGFloat(-0.5*UIConstant.controlPanelHeight)
    UIView.animateWithDuration(0.4, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity,
      options: [], animations: { [weak self]() -> Void in
        if let strongSelf = self {
          strongSelf.view.layoutIfNeeded()
        }
      }, completion: nil)
  }
  
  private func hideControlPanel() {
    self.view.layoutIfNeeded()
    self.controlPanelHorizontalPositionConstraint.constant = CGFloat(-1.0*UIConstant.controlPanelHeight)
    UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: {  [weak self]() -> Void in
      if let strongSelf = self {
        strongSelf.view.layoutIfNeeded()
      }
    }, completion: nil)
  }
  
  private func resetTimer() {
    pauseTimer()
    timer.invalidate(countUp: timerCountUp, level: model.gameLevel)
    controlPanelView.timerString = timer.toString()
  }
  
  private func startTimer() {
    resetTimer()
    intervalPoller = NSTimer.schedule(repeatInterval: 1.0, block: poll)
  }
  
  private func pauseTimer() {
    if let poller = intervalPoller {
      poller.invalidate()
      intervalPoller = nil
    }
  }
  
  private func resumeTimer() {
    pauseTimer()
    intervalPoller = NSTimer.schedule(repeatInterval: 1.0, block: poll)
  }
  
  private func resetCounter() {
    counter = 0;
    controlPanelView.count = counter;
  }
  
  private func incrementCounter() {
    controlPanelView.count = ++counter
  }
  
  private func decrementCounter() {
    controlPanelView.count = --counter
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
            incrementCounter()
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
    if replayMode {
      return false
    }
    if let disk = diskViewToDiskMap[diskView] {
      return model.shouldDiskMove(disk)
    } else {
      return false
    }
  }
  
  // MARK: NSTimer closure
  private func poll(nsTimer:NSTimer!) {
    Utility.dispatchToMainThread { [weak self]() -> Void in
      if let strongSelf = self {
        let timerStatus = strongSelf.timerCountUp ? strongSelf.timer.increment() : strongSelf.timer.decrement()
        strongSelf.controlPanelView.timerString = strongSelf.timer.toString()
        if !timerStatus {
          // game lost
          strongSelf.model.gameState = .Ended(hasWon: false)
        }
      }
    }
  }
  
  // MARK: hanoi solver
  
  private func animateDisks(operationStack operationStack: [(from: PoleType, to: PoleType)], var index: Int) {
    if index == operationStack.count ||
      (model.gameState != .Started && model.gameState != .Resumed && model.gameState != .Paused) ||
      (model.previousGameState == .Paused && model.gameState == .Started) {
      // algorithm finished or game not running or game restarted, stop the animation
        replayMode = false
        return
    }
    if model.gameState != .Paused { // when in paused state, schedule delay timer without animation
      let operation = operationStack[index++]
      if let diskView = diskViewsForPole[operation.from]?.last {
        if let disk = diskViewToDiskMap[diskView] {
          if model.shouldDiskPlaceToPole(disk: disk, pole: operation.to) {
            moveDisk(diskView, toPole: operation.to, animated: true)
            NSTimer.schedule(delay: 0.6) { [weak self]timer -> Void in
              if let strongSelf = self {
                strongSelf.placeDisk(diskView, onPole: operation.to, animated: true)
                strongSelf.incrementCounter()
              }
            }
          }
        }
      }
    }
    NSTimer.schedule(delay: 0.95){ [weak self]timer -> Void in
      Utility.dispatchToMainThread { () -> Void in
        if let strongSelf = self {
          strongSelf.animateDisks(operationStack: operationStack, index: index)
        }
      }
    }
  }
  
  // MARK: timerLabel double tap event
  @objc private func timerLabelTapped() {
    if replayMode {
      return
    }
    print("start solving...")
    replayMode = true
    model.solve(original: .OriginalPole, buffer: .BufferPole, destination: .DestinationPole, numDisks: model.gameLevel)
    print("steps: \(model.operationStack.count) \n \(model.operationStack)")
    let operationStack = model.operationStack
    animateDisks(operationStack: operationStack, index: 0);
  }
  
}

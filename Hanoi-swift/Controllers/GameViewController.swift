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
  
  var model = GameLogic.defaultModel
  var gameSceneView: GameSceneView!
  var controlPanelView: ControlPanelView!
  var diskViewToDiskMap = [DiskView:Disk]()
  
  override func loadView() {
    // setup game scene
    gameSceneView = UIView.viewFromNib(XibNames.GameSceneViewXibName, owner: self) as! GameSceneView
    self.view = gameSceneView
    setupControlPanel()
  }
  
  private func setupControlPanel() {
    controlPanelView = UIView.viewFromNib(XibNames.ControlPanelViewXibName, owner: self) as! ControlPanelView
    self.view.addSubview(controlPanelView);
    controlPanelView.setTranslatesAutoresizingMaskIntoConstraints(false)
    let views = ["controlPanel": controlPanelView]
    let metrics = ["panelHeight": 60]
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[controlPanel]|", options: nil, metrics: nil, views: views))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[controlPanel(panelHeight)]", options: nil, metrics: metrics, views: views))
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
  
  @IBAction func dotPressed() {
    let menuVC = MenuViewController()
    menuVC.view.frame = self.view.bounds
    menuVC.transitioningDelegate = self
    menuVC.modalPresentationStyle = .Custom
    self.presentViewController(menuVC, animated: true, completion: nil)
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
        assert(removedDisk == disk, "removed disk should be disk")
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

//
//  GameViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIViewControllerTransitioningDelegate,
ViewControllerProtocol, DiskViewDataSource, DiskViewDelegate {

  @IBOutlet weak var dotButton: ControlPanelButton!
  
  var model = GameLogic.defaultModel
  var gameSceneView: GameSceneView!
  var controlPanelView: ControlPanelView!
  
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
    initDisks()
  }
  
  @IBAction func dotPressed() {
    let menuVC = MenuViewController()
    menuVC.view.frame = self.view.bounds
    menuVC.transitioningDelegate = self
    menuVC.modalPresentationStyle = .Custom
    self.presentViewController(menuVC, animated: true, completion: nil)
  }
  
  func initDisks() {
    // can also be bufferPole or destinationPole.
    let poleBaseFrame = gameSceneView.originalPole.poleBase.frame
    let poleStickFrame = gameSceneView.originalPole.poleStick.frame
    let poleStickCenter = gameSceneView.originalPole.poleStick.center
    
    let poleBaseWidth = Double(poleBaseFrame.size.width)
    let poleStickHeight = Double(poleStickFrame.size.height)
    let poleStickCenterX = poleStickCenter.x
    let numberOfDisks = 9; // TODO: from GameLogic
    
    var disks = model.createDisks(largestDiskWidth: poleBaseWidth - DiskConstant.diskWidthOffset,
      numberOfDisks: numberOfDisks, maximumDiskPileHeight: poleStickHeight)
    for disk in disks {
      let diskView = UIView.viewFromNib(XibNames.DiskViewXibName) as! DiskView
      let diskWidth = CGFloat(disk.width)
      let diskHeight = CGFloat(Disk.height)
      let diskCenterX = poleStickCenterX
      let diskCenterY = poleBaseFrame.origin.y -
        CGFloat(model.pileHeight(poleType: .OriginalPole) + 0.5*Disk.height)
      gameSceneView.originalPole.addSubview(diskView)
      diskView.frame = CGRectMake(0, 0, diskWidth, diskHeight)
      diskView.center = CGPointMake(diskCenterX, diskCenterY)
      model.placeDisk(disk, onPole: .OriginalPole)
      diskView.dataSource = self
      diskView.delegate = self
    }
  }
  
  // MARK: UIViewControllerTransitioningDelegate methods
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController
    presenting: UIViewController, sourceController source: UIViewController)
    -> UIViewControllerAnimatedTransitioning?
  {
    RippleTransitionAnimator.defaultAnimator.presenting = true
    return RippleTransitionAnimator.defaultAnimator
  }
  
  func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return nil
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning?
  {
    RippleTransitionAnimator.defaultAnimator.presenting = false
    return RippleTransitionAnimator.defaultAnimator
  }
  
  
  func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return nil
  }

  // MARK: DiskViewDataSource methods
  func getGameSceneView() -> GameSceneView? {
    return gameSceneView
  }
  
}

//
//  GameViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIViewControllerTransitioningDelegate, ViewControllerProtocol {

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
    createDisks()
  }
  
  @IBAction func dotPressed() {
    let menuVC = MenuViewController()
    menuVC.view.frame = self.view.bounds
    menuVC.transitioningDelegate = self
    menuVC.modalPresentationStyle = .Custom
    self.presentViewController(menuVC, animated: true, completion: nil)
  }
  
  func createDisks() {
    let poleBaseFrame = gameSceneView.originalPole.poleBase.frame
    let poleStickFrame = gameSceneView.originalPole.poleStick.frame
    
    let poleBaseWidth = Double(poleBaseFrame.size.width)
    let poleStickHeight = Double(poleStickFrame.size.height)
    let poleBaseCenterX = Double(poleBaseFrame.origin.x + poleBaseFrame.size.width / 2.0)
    let numberOfDisks = 9; // TODO: from GameLogic
    
    model.createDisksData(largestDiskWidth: poleBaseWidth - DiskConstant.diskWidthOffset, numberOfDisks: numberOfDisks,
      maximumDiskPileHeight: poleStickHeight)
    for disk in model.originalStack {
      let diskView = UIView.viewFromNib(XibNames.DiskViewXibName) as! DiskView
      let diskWidth = CGFloat(disk.width)
      let diskHeight = CGFloat(disk.height)
      let diskPositionX = CGFloat(poleBaseCenterX - disk.width / 2.0)
      let diskPositionY = poleBaseFrame.origin.y - CGFloat(disk.distanceToPoleBase) - CGFloat(disk.height)
      gameSceneView.originalPole.addSubview(diskView)
      diskView.frame = CGRectMake(diskPositionX, diskPositionY, diskWidth, diskHeight)
      
      
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

}

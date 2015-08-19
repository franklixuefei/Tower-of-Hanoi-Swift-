//
//  GameViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

  var model = GameLogic.defaultModel
  var gameSceneView: GameSceneView!
  
  override func loadView() {
    gameSceneView = UIView.viewFromNib(XibNames.GameSceneViewXibName) as! GameSceneView
    self.view = gameSceneView
    self.view.backgroundColor = UIColor.color(hexValue: 0xF4F4F4, alpha: 1.0)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    createDisks()
  }
  
  func createDisks() {
    // Force layout immediately in order to get the views' actual frame
    gameSceneView.setNeedsLayout()
    gameSceneView.layoutIfNeeded()
    
    let poleBaseFrame = gameSceneView.originalPole.poleBase.frame
    let poleStickFrame = gameSceneView.originalPole.poleStick.frame
    
    let poleBaseWidth = Double(poleBaseFrame.size.width);
    let poleStickHeight = Double(poleStickFrame.size.height);
    let poleBaseCenterX = Double(poleBaseFrame.origin.x + poleBaseFrame.size.width / 2.0)
    let numberOfDisks = 5; // TODO: from GameLogic
    
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

}

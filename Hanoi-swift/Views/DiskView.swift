//
//  DiskView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/18/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class DiskView: UIView {

  weak var dataSource: DiskViewDataSource?
  weak var delegate: DiskViewDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panned:"))
  }
  
  func panned(gesture: UIPanGestureRecognizer) {
    if let gameSceneView = dataSource?.getGameSceneView() {
      switch gesture.state {
      case .Began:
        break
      case .Changed:
        let translation = gesture.translationInView(gameSceneView)
        self.frame = CGRectMake(self.frame.origin.x + translation.x, self.frame.origin.y + translation.y,
          self.frame.size.width, self.frame.size.height)
        gesture.setTranslation(CGPointZero, inView: gameSceneView)
      case .Ended, .Failed, .Cancelled:
        println("ended, failed, cancelled")
        break
      default:
        break
      }
    }
  }
}

protocol DiskViewDataSource: class {
  func getGameSceneView() -> GameSceneView?
}

protocol DiskViewDelegate: class {
  
}

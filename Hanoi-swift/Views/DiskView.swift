//
//  DiskView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/18/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class DiskView: UIView {
  
  weak var delegate: DiskViewDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panned:"))
  }
  
  func panned(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .Began:
      self.superview?.bringSubviewToFront(self)
    case .Changed:
      let translation = gesture.translationInView(self.superview!)
      self.frame = CGRectMake(self.frame.origin.x + translation.x, self.frame.origin.y + translation.y,
        self.frame.size.width, self.frame.size.height)
      gesture.setTranslation(CGPointZero, inView: self.superview!)
    default:
      break
    }
    delegate?.gestureState(gesture.state, onDisk: self)
  }
}

protocol DiskViewDelegate: class {
  func gestureState(state: UIGestureRecognizerState, onDisk diskView: DiskView)
}

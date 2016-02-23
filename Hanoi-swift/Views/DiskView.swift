//
//  DiskView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/18/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class DiskView: UIView, UIGestureRecognizerDelegate {
  
  weak var delegate: DiskViewDelegate?
  
  @IBOutlet weak var disk: UIView! {
    didSet {
      disk.backgroundColor = UIColor.color(hexValue: UInt(UIConstant.diskColor), alpha: 1.0)
      disk.borderColor = UIColor.color(hexValue: UInt(UIConstant.diskBorderColor), alpha: 1.0)
      disk.borderWidth = CGFloat(UIConstant.diskBorderWidth)
      disk.cornerRadius = CGFloat(UIConstant.diskCornerRadius)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    let panGesture = UIPanGestureRecognizer(target: self, action: "panned:")
    panGesture.delegate = self
    self.addGestureRecognizer(panGesture)
  }
  
  @objc private func panned(gesture: UIPanGestureRecognizer) {
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
  
  // MARK: UIGestureRecognizerDelegate methods
  override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let delegate = self.delegate {
      return delegate.shouldBeginRecognizingGestureForDisk(self)
    }
    return false
  }
}

protocol DiskViewDelegate: class {
  func gestureState(state: UIGestureRecognizerState, onDisk diskView: DiskView)
  func shouldBeginRecognizingGestureForDisk(diskView: DiskView) -> Bool
}

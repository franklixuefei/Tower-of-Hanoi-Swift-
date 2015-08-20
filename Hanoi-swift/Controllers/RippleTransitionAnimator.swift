//
//  RippleTransitionAnimator.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/20/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class RippleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  static let defaultAnimator = RippleTransitionAnimator()
  
  weak var transitionContext: UIViewControllerContextTransitioning?
  var presenting = true
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.4;
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    
    var containerView = transitionContext.containerView()
    var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
    var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    var button = (fromViewController as! ViewControllerProtocol).dotButton
    
    if presenting {
      containerView.addSubview(toViewController.view)
    } else {
      containerView.addSubview(fromViewController.view)
    }
    
    var circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
    let viewBoundWidth = CGRectGetWidth(toViewController.view.bounds)
    let viewBoundHeight = CGRectGetHeight(toViewController.view.bounds)
    let buttonBoundWidth = CGRectGetWidth(button.bounds)
    let buttonBoundHeight = CGRectGetHeight(button.bounds)
    let radius = sqrt(pow(viewBoundWidth - button.center.x, 2) + pow(viewBoundHeight - button.center.y, 2))
    let dx = -(radius-0.5*buttonBoundWidth), dy = -(radius-0.5*buttonBoundHeight)
    var circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, dx, dy))
    
    var maskLayer = CAShapeLayer()
    maskLayer.path = circleMaskPathFinal.CGPath
    if presenting {
      toViewController.view.layer.mask = maskLayer
    } else {
      fromViewController.view.layer.mask = maskLayer
    }
    
    
    var maskLayerAnimation = CABasicAnimation(keyPath: "path")
    maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    if presenting {
      maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
      maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
    } else {
      maskLayerAnimation.fromValue = circleMaskPathFinal.CGPath
      maskLayerAnimation.toValue = circleMaskPathInitial.CGPath
    }
    
    // This is important. This prevents the CGPath from snapping back to the original.
    // Reference: http://oleb.net/blog/2012/11/prevent-caanimation-snap-back/
    if !presenting {
      maskLayer.path = circleMaskPathInitial.CGPath
    }
    
    maskLayerAnimation.duration = self.transitionDuration(transitionContext)
    maskLayerAnimation.delegate = self
    maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
  }
  
  override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
    self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
    let key = presenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey
    self.transitionContext?.viewControllerForKey(key)?.view.layer.mask = nil
  }
}

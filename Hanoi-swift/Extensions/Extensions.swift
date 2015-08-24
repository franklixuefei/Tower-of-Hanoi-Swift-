//
//  Inspectables.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/18/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  @IBInspectable var borderColor: UIColor? {
    get {
      return UIColor(CGColor: layer.borderColor)
    }
    set {
      layer.borderColor = newValue?.CGColor
    }
  }
}

extension UIView {
  class func viewFromNib(nib: String?) -> UIView? {
    let views = NSBundle.mainBundle().loadNibNamed(nib, owner: nil, options: nil)
    return views.first as? UIView
  }
  
  class func viewFromNib(nib: String?, owner: AnyObject?) -> UIView? {
    let views = NSBundle.mainBundle().loadNibNamed(nib, owner: owner, options: nil)
    return views.first as? UIView
  }
  
  class func crossFadeViews(viewsToFadeOut views1: [UIView], viewsToFadeIn views2: [UIView],
    animationDuration duration: Double, completionBlock: (() -> Void)?) {
    UIView.animateWithDuration(duration, animations: { () -> Void in
      for view in views1 {
        view.layer.opacity = 0
      }
      for view in views2 {
        view.layer.opacity = 1
      }
    }) { (completed) -> Void in
      if completed {
        completionBlock?()
      }
    }
  }
}

extension UIColor {
  class func color(#hexValue: UInt, alpha: CGFloat) -> UIColor {
    return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0,
      blue: CGFloat((hexValue & 0xFF)) / 255.0, alpha: alpha)
  }
  
  class func color(#r: UInt, g: UInt, b: UInt, a: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
  }
}

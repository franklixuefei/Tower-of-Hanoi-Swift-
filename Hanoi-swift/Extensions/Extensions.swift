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
  
  func applyDropShadow(bezierPathEnabled: Bool = true) {
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.blackColor().CGColor
    self.layer.shadowOffset = CGSizeMake(0, 1)
    self.layer.shadowOpacity = 0.3
    self.layer.shadowRadius = 1.5
    if bezierPathEnabled {
      self.layer.shadowPath = UIBezierPath(rect: self.bounds).CGPath
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

extension UIFont {
  class func ayuthayaFontWithSize(size: CGFloat) -> UIFont? {
    return self(name: "ayuthaya", size: size)
  }
}

extension NSLayoutConstraint {
  
  // reference: https://github.com/evgenyneu/center-vfl
  class func centerViewToSuperview(#view: UIView, superview: UIView) {
    assert(contains(superview.subviews as! [UIView], view), "view is not a subview of superview")
    view.setTranslatesAutoresizingMaskIntoConstraints(false)
    let views = ["superview":superview, "view":view]
    let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[superview]-(<=1)-[view]",
      options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
    superview.addConstraints(verticalConstraints)
    
    let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[superview]-(<=1)-[view]",
      options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
    
    superview.addConstraints(horizontalConstraints)
  }
}

// Code reference: https://github.com/honghaoz/2048-Solver-AI
extension UIImage {
  class func imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSetFillColorWithColor(context, color.CGColor)
    CGContextFillRect(context, rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
  
  class func imageWithBorderRectangle(size: CGSize, borderWidth: CGFloat, borderColor: UIColor,
    fillColor: UIColor = UIColor.clearColor()) -> UIImage {
    UIGraphicsBeginImageContext(size)
    let context = UIGraphicsGetCurrentContext()
    let rect = CGRect(origin: CGPointZero, size: size)
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor)
    CGContextFillRect(context, rect)
    
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
    CGContextSetLineWidth(context, borderWidth)
    CGContextStrokeRect(context, rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
}

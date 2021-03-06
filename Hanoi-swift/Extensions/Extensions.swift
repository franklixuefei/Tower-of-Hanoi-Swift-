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
      return UIColor(CGColor: layer.borderColor!)
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
  
  func applyDropShadow(cornerRadius radius:CGFloat = 0) {
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor(white: 0.2, alpha: 1.0).CGColor
    self.layer.shadowOffset = CGSizeMake(0, 1)
    self.layer.shadowOpacity = 0.5
    self.layer.shadowRadius = 1.5
    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).CGPath
  }
}

extension UIColor {
  class func color(hexValue hexValue: UInt, alpha: CGFloat) -> UIColor {
    return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0,
      blue: CGFloat((hexValue & 0xFF)) / 255.0, alpha: alpha)
  }
  
  class func color(r r: UInt, g: UInt, b: UInt, a: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
  }
}

extension UIFont {
  class func ayuthayaFont(size size: CGFloat) -> UIFont? {
    return self.init(name: "Ayuthaya", size: size)
  }
  class func lucidaFont(size size:CGFloat) -> UIFont? {
    return self.init(name: "LucidaHandwriting-Italic", size: size)
  }
}

extension NSLayoutConstraint {
  
  // reference: https://github.com/evgenyneu/center-vfl
  class func centerViewToSuperview(view view: UIView, superview: UIView) {
    assert((superview.subviews ).contains(view), "view is not a subview of superview")
    view.translatesAutoresizingMaskIntoConstraints = false
    let views = ["superview":superview, "view":view]
    let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[superview]-(<=1)-[view]",
      options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
    superview.addConstraints(verticalConstraints)
    
    let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[superview]-(<=1)-[view]",
      options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
    
    superview.addConstraints(horizontalConstraints)
  }
  
  class func pinViewToSuperview(view view: UIView, superview: UIView, paddings:(h:CGFloat, v:CGFloat) = (h:0, v:0)) {
    assert((superview.subviews ).contains(view), "view is not a subview of superview")
    view.translatesAutoresizingMaskIntoConstraints = false
    let views = ["view": view]
    superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(paddings.h)-[view]-\(paddings.h)-|", options: [],
      metrics: nil, views: views))
    superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(paddings.v)-[view]-\(paddings.v)-|", options: [],
      metrics: nil, views: views))
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

// Code reference: https://gist.github.com/natecook1000/b0285b518576b22c4dc8
extension NSTimer {
  /**
  Creates and schedules a one-time `NSTimer` instance.
  
  :param: delay The delay before execution.
  :param: handler A closure to execute after `delay`.
  
  :returns: The newly-created `NSTimer` instance.
  */
  class func schedule(delay delay: NSTimeInterval, block: NSTimer! -> Void) -> NSTimer {
    let fireDate = delay + CFAbsoluteTimeGetCurrent()
    let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, block)
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
    return timer
  }
  
  /**
  Creates and schedules a repeating `NSTimer` instance.
  
  :param: repeatInterval The interval between each execution of `handler`. Note that individual calls may be delayed; subsequent calls to `handler` will be based on the time the `NSTimer` was created.
  :param: handler A closure to execute after `delay`.
  
  :returns: The newly-created `NSTimer` instance.
  */
  class func schedule(repeatInterval interval: NSTimeInterval, block: NSTimer! -> Void) -> NSTimer {
    let fireDate = interval + CFAbsoluteTimeGetCurrent()
    let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, block)
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
    return timer
  }
}

class Utility {
  class func delay(delay:Double, block:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), block)
  }
  
  class func dispatchToMainThread(block: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), block)
  }
  
  class func getTimeComponentsFromSeconds(seconds:Int) -> (hours:Int, minutes:Int, seconds:Int) {
    let hour = seconds / 3600
    let minute = (seconds/60) % 60
    let second = seconds % 60
    return (hours:hour, minutes:minute, seconds:second)
  }
}

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
}

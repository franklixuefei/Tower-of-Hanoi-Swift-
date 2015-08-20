//
//  ControlPanelView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/19/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class ControlPanelView: UIView {
  
}

class ControlPanelButton: UIButton {
  override var highlighted: Bool {
    get {
      return super.highlighted
    }
    set {
      if newValue { // highlighted = true
        backgroundColor = UIColor.color(hexValue: 0x777777, alpha: 1)
      } else {
        backgroundColor = UIColor.color(hexValue: 0x999999, alpha: 1)
      }
      super.highlighted = newValue
    }
  }
}

//
//  ControlPanelView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/19/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class ControlPanelView: UIView {
  
  @IBOutlet weak var dotButton: BaseButton!
  @IBOutlet weak var levelLabel: UILabel! {
    didSet {
      levelLabel.borderWidth = CGFloat(UIConstant.controlPanelLevelLabelBorderWidth)
      levelLabel.borderColor = UIColor.color(hexValue: UInt(UIConstant.controlPanelLevelLabelColor), alpha: 1.0)
      levelLabel.textColor = UIColor.color(hexValue: UInt(UIConstant.controlPanelLevelLabelColor), alpha: 1.0)
      levelLabel.font = UIFont.ayuthayaFont(size: CGFloat(UIConstant.controlPanelLevelLabelFontSize))
    }
  }
  @IBOutlet weak var timerLabel: UILabel! {
    didSet {
      timerLabel.textColor = UIColor.color(hexValue: UInt(UIConstant.controlPanelTimerLabelColor), alpha: 1.0)
      timerLabel.font = UIFont.ayuthayaFont(size: CGFloat(UIConstant.controlPanelTimerLabelFontSize))
    }
  }
  @IBOutlet weak var counterLabel: UILabel! {
    didSet {
      counterLabel.textColor = UIColor.color(hexValue: UInt(UIConstant.controlPanelCounterLabelColor), alpha: 1.0)
      counterLabel.font = UIFont.ayuthayaFont(size: CGFloat(UIConstant.controlPanelCounterLabelFontSize))
    }
  }
  
  var level: Int = LogicConstant.defaultLevel {
    didSet {
      levelLabel.text = "\(level)"
    }
  }
  
  var timerString: String? {
    didSet {
      timerLabel.text = timerString
    }
  }
  
  var count: Int = 0 {
    didSet {
      counterLabel.text = "\(count)"
    }
  }
  
}


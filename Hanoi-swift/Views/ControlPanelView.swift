//
//  ControlPanelView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/19/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class ControlPanelView: UIView {
  
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var counterLabel: UILabel!
  
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


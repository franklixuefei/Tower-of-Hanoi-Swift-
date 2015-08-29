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
  
  var level: Int = LogicConstant.defaultLevel {
    didSet {
      levelLabel.text = "\(level)"
    }
  }
}


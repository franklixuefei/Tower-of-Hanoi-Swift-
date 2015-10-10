//
//  MenuSettingsControlView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/28/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuSettingsControlView: UIView {

  @IBOutlet weak var controlLabel: UILabel! {
    didSet {
      controlLabel.textColor = UIColor.whiteColor()
    }
  }
  @IBOutlet weak var controlContainerView: UIView!
  
  var controlName: String? {
    didSet {
      controlLabel.text = controlName! + ":"
    }
  }
  
  var controlView: UIView? {
    didSet {
      controlContainerView.addSubview(controlView!)
      controlView!.translatesAutoresizingMaskIntoConstraints = false
      let views = ["view": controlView!]
      controlContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [],
        metrics: nil, views: views))
      controlContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [],
        metrics: nil, views: views))
    }
  }
  
  
}

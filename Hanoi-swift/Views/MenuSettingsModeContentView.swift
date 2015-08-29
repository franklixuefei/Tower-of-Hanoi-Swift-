//
//  MenuSettingsModeContentView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/29/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuSettingsModeContentView: UIView {
  @IBOutlet weak var mode: UILabel! {
    didSet {
      mode.textColor = UIColor.whiteColor()
    }
  }

  var modeName: String? {
    didSet {
      mode.text = modeName!
    }
  }
}

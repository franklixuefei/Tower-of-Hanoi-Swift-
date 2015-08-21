
//
//  PoleView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class PoleView: UIView {

  @IBOutlet weak var poleBase: UIView!
  @IBOutlet weak var poleStick: UIView!
  
  var poleType: PoleType!
  
  var poleBaseWidth: CGFloat {
    get {
      return CGRectGetWidth(poleBase.frame)
    }
  }
  
  var poleStickHeight: CGFloat {
    get {
      return CGRectGetHeight(poleStick.frame)
    }
  }
  
}

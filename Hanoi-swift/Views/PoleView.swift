//
//  PoleView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 2/23/16.
//  Copyright © 2016 Frank Li. All rights reserved.
//

import UIKit

class PoleView: UIView {

  @IBOutlet weak var poleBase: UIView! {
    didSet { // This effectively eliminates the abuse of awakeFromNib()
      poleBase.cornerRadius = CGFloat(UIConstant.pegBaseCornerRadius)
      poleBase.backgroundColor = UIColor.color(hexValue: UInt(UIConstant.pegBaseColor), alpha: 1.0)
    }
  }
  @IBOutlet weak var poleStick: UIView! {
    didSet { // This effectively eliminates the abuse of awakeFromNib()
      poleStick.cornerRadius = CGFloat(UIConstant.pegStickCornerRadius)
      poleStick.backgroundColor = UIColor.color(hexValue: UInt(UIConstant.pegStickColor), alpha: 1.0)
    }
  }
  
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

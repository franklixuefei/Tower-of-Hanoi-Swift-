
//
//  PoleView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class PoleView: UIView {

  private var poleView: UIView!
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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    poleView = UIView.viewFromNib(XibNames.PoleViewXibName, owner: self)
    self.addSubview(poleView)
    poleView.setTranslatesAutoresizingMaskIntoConstraints(false)
    let viewsDict = ["pole": poleView]
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[pole]|", options: nil, metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[pole]|", options: nil, metrics: nil, views: viewsDict))
  }
  
}

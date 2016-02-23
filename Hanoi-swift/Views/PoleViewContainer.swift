
//
//  PoleView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class PoleViewContainer: UIView {

  var poleView: PoleView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    poleView = UIView.viewFromNib(XibNames.PoleViewXibName, owner: self) as! PoleView
    self.addSubview(poleView)
    poleView.translatesAutoresizingMaskIntoConstraints = false
    let viewsDict = ["pole": poleView]
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[pole]|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[pole]|", options: [], metrics: nil, views: viewsDict))
  }
  
}

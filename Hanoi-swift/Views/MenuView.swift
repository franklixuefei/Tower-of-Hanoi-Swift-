//
//  MenuView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/20/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuView: UIView {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var menuContainerView: UIView!
  
  func pinViewToContainerView(view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    let views = ["view": view]
    menuContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [],
      metrics: nil, views: views))
    menuContainerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [],
      metrics: nil, views: views))
  }
  
}

//
//  MenuResultViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/25/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol MenuResultViewControllerDelegate: class {
  func okButtonPressed()
}

class MenuResultViewController: MenuBaseViewController {

  var hasWon = true
  // TODO: more properties for constructing the wording of the result.
  var okButton: MenuButton!
  var scrollView: MenuScrollView!
  weak var delegate: MenuResultViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.contentViewWidthConstraint.constant = CGFloat(UIConstant.menuContentViewWidthLarge)
    scrollView = MenuScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Height, relatedBy: .Equal, toItem: nil,
      attribute: .Height, multiplier: 0, constant: CGFloat(UIConstant.menuScrollViewHeightLarge)))
    contentView.addSubview(scrollView)
    okButton = MenuButton(type: .Custom) 
    if hasWon {
      okButton.setTitle("Got It!", forState: .Normal)
      // TODO: result wording textView added as a subview to scrollView
    } else {
      okButton.setTitle("Try Again", forState: .Normal)
      // TODO: result wording textView added as a subview to scrollView
    }
    contentView.addSubview(okButton)
    okButton.addTarget(self, action: "okPressed", forControlEvents: .TouchUpInside)
  }
  
  @objc private func okPressed() {
    delegate?.okButtonPressed()
  }
}

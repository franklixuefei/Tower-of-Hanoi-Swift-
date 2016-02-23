//
//  MenuResultViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/25/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol MenuResultViewControllerDelegate: class {
  func okButtonPressed(nextLevel: Int)
}

class MenuResultViewController: MenuBaseViewController {

  var hasWon = true
  var timeElapsedInSeconds = 0 // set by MenuViewController
  var stepsTaken: Int = 0
  var numDisksOnDest: Int = 0 // must starts with the biggest disk
  var level: Int = LogicConstant.minimumLevel

  var okButton: MenuButton!
  var scrollView: MenuScrollView!
  var outroView: UILabel!

  weak var delegate: MenuResultViewControllerDelegate?
  
  // MARK: - View controller life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.contentViewWidthConstraint.constant = CGFloat(UIConstant.menuContentViewWidthLarge)
    scrollView = MenuScrollView(verticalDirection: true,
      inset: CGFloat(UIConstant.menuResultScrollViewInset), padding: CGFloat(UIConstant.menuResultScrollViewSpacing))
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Height, relatedBy: .Equal, toItem: nil,
      attribute: .Height, multiplier: 0, constant: CGFloat(UIConstant.menuScrollViewHeightLarge)))
    contentView.addSubview(scrollView)
    outroView = UILabel()
    outroView.font = UIFont.ayuthayaFont(size: CGFloat(UIConstant.menuOutroFontSize))
    outroView.numberOfLines = 0
    outroView.textColor = UIColor.color(hexValue: UInt(UIConstant.buttonTitleColorForNormalState), alpha: 1.0)
    scrollView.addSubview(outroView)
    okButton = MenuButton(type: .Custom)
    contentView.addSubview(okButton)
    okButton.addTarget(self, action: "okPressed", forControlEvents: .TouchUpInside)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    var timeString = ""
    let components = Utility.getTimeComponentsFromSeconds(timeElapsedInSeconds)
    if components.hours != 0 {
      timeString += "\(components.hours) hour" + ((components.hours > 1) ? "s " : " ")
    }
    if components.minutes != 0 {
      timeString += "\(components.minutes) minute" + ((components.minutes > 1) ? "s " : " ")
    }
    if components.seconds != 0 {
      timeString += ((components.hours != 0 || components.minutes != 0) ? "and " : "") +
        "\(components.seconds) second" + ((components.seconds > 1) ? "s" : "")
    }
    if hasWon {
      okButton.setTitle("Got It!", forState: .Normal)
      outroView.text = "You conquered the Tower in just \(stepsTaken) steps within \(timeString). Great Job! " +
        ((level == LogicConstant.maximumLevel) ?
          "You have passed the hardest level! Play again and beat your best result!" :
          "Now get your hands dirty on level \(++level)!")
    } else {
      okButton.setTitle("Try Again", forState: .Normal)
      outroView.text = "It just isn't your day, is it? " +
        ((numDisksOnDest > 0) ?
          ("But you've already moved over \(numDisksOnDest) " +
          ((numDisksOnDest > 1) ? "disks" : "disk") +
          " within \(timeString). Keep up and better luck next time!") :
          "Try harder next time and I'm sure you will play better!")
    }
  }
  
  // MARK: - IBActions
  @objc private func okPressed() {
    delegate?.okButtonPressed(level)
  }
}

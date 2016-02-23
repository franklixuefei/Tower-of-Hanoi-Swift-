//
//  MenuSettingsViewController.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/24/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol MenuSettingsViewControllerDelegate: class {
  func backButtonPressed()
  func modeSelected(mode: String)
  func currentGameLevel() -> Int
  func gameLevelSliderChanged(level: Int)
}

class MenuSettingsViewController: MenuBaseViewController, UIScrollViewDelegate {

  var backButton: MenuButton!
  var scrollView: MenuScrollView!
  var sliderView: MenuSlider!
  weak var delegate: MenuSettingsViewControllerDelegate?
  
  // MARK: - View controller life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.contentViewWidthConstraint.constant = CGFloat(UIConstant.menuContentViewWidthLarge)
    scrollView = MenuScrollView(verticalDirection: true, inset: CGFloat(UIConstant.menuSettingsScrollViewInset))
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Height, relatedBy: .Equal, toItem: nil,
      attribute: .Height, multiplier: 0, constant: CGFloat(UIConstant.menuScrollViewHeightSmall)))
    
    setupModeSettingsView()
    setupLevelSettingsView()

    contentView.addSubview(scrollView)
    backButton = MenuButton(type: .Custom) 
    backButton.setTitle("Back", forState: .Normal)
    contentView.addSubview(backButton)
    backButton.addTarget(self, action: "backPressed", forControlEvents: .TouchUpInside)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    sliderView.value = Float(delegate?.currentGameLevel() ?? Float(LogicConstant.minimumLevel))
  }
  
  // MARK: - Helpers
  private func setupModeSettingsView() {
    let modeSettingsControl =
      UIView.viewFromNib(XibNames.MenuSettingsControlViewXibName, owner: self) as! MenuSettingsControlView
    modeSettingsControl.controlName = "Mode"
    let modeScrollView = MenuScrollView(verticalDirection: false, parentScrollView: false)
    modeScrollView.pagingEnabled = true
    modeScrollView.delegate = self
    modeSettingsControl.controlView = modeScrollView
    let casualContent =
      UIView.viewFromNib(XibNames.MenuSettingsModeContentViewXibName, owner: self) as! MenuSettingsModeContentView
    casualContent.modeName = LogicConstant.casualModeString
    let challengeContent =
      UIView.viewFromNib(XibNames.MenuSettingsModeContentViewXibName, owner: self) as! MenuSettingsModeContentView
    challengeContent.modeName = LogicConstant.challengeModeString
    modeScrollView.addSubview(casualContent)
    modeScrollView.addSubview(challengeContent)
    modeScrollView.addConstraint(NSLayoutConstraint(item: casualContent, attribute: .Width, relatedBy: .Equal,
      toItem: modeScrollView, attribute: .Width, multiplier: 1, constant: 0))
    modeScrollView.addConstraint(NSLayoutConstraint(item: challengeContent, attribute: .Width, relatedBy: .Equal,
      toItem: modeScrollView, attribute: .Width, multiplier: 1, constant: 0))
    scrollView.addSubview(modeSettingsControl)
  }
  
  private func setupLevelSettingsView() {
    let levelSettingsControl =
      UIView.viewFromNib(XibNames.MenuSettingsControlViewXibName, owner: self) as! MenuSettingsControlView
    levelSettingsControl.controlName = "Level"
    sliderView = MenuSlider()
    sliderView.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
    sliderView.minimumValue = Float(LogicConstant.minimumLevel)
    sliderView.maximumValue = Float(LogicConstant.maximumLevel)
    levelSettingsControl.controlView = sliderView
    scrollView.addSubview(levelSettingsControl)
  }
  
  // MARK: - IBActions
  @objc private func backPressed() {
    delegate?.backButtonPressed()
  }
  
  @objc private func sliderValueChanged(sender: MenuSlider) {
    let level = Int(sender.value)
    delegate?.gameLevelSliderChanged(level)
  }
  
  // MARK: - UIScrollViewDelegate methods
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    if let menuScrollView = scrollView as? MenuScrollView {
      let contents = menuScrollView.contents
      let width = menuScrollView.frame.size.width
      let index = Int((menuScrollView.contentOffset.x + width / 2.0) / width)
      delegate?.modeSelected((contents[index] as! MenuSettingsModeContentView).modeName!)
    }
  }

}

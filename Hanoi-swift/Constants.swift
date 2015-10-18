//
//  Constants.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/19/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import Foundation

struct XibNames {
  static let GameSceneViewXibName = "GameSceneView"
  static let PoleViewXibName = "PoleView"
  static let DiskViewXibName = "DiskView"
  static let ControlPanelViewXibName = "ControlPanelView"
  static let MenuViewXibName = "MenuView"
  static let MenuSettingsControlViewXibName = "MenuSettingsControlView"
  static let MenuSettingsModeContentViewXibName = "MenuSettingsModeContentView"
}

struct LogicConstant {
  static let defaultLevel = 5
  static let maximumLevel = 9
  static let minimumLevel = 2
  static let gameTitle = "Tower of Hanoi"
  static let pausedTitle = "Paused"
  static let winTitle = "You Win!"
  static let loseTitle = "You Lose..."
  static let casualModeString = "Casual"
  static let challengeModeString = "Challenge"
  static let timerHourUpperBound = 99
  static let secondBase = 60
  static let minuteBase = 60
}

struct InfrastructureConstant {
  static let gameStateNotificationChannelName = "gameState"
  static let gameModeNotificationChannelName = "gameMode"
  static let gameLevelNotificationChannelName = "gameLevel"
}

struct UIConstant {
  static let animationSpringWithDamping = 0.45
  static let animationSpringVelocity = 1.0
  static let maximumDiskHeight = 25.0
  static let largeSmallDiskWidthRatio = 3.0
  static let diskWidthOffset = 20.0
  static let diskHeightOffset = 12.0
  static let controlPanelHeight = 120.0
  static let rippleAnimatorTransitionDuration = 0.4
  static let buttonsVerticalSpacing = 10.0
  static let buttonsHorizontalSpacing = 20.0
  static let menuContentViewWidthSmall = 220.0
  static let menuContentViewWidthLarge = 300.0
  static let buttonHeight = 44.0
  static let buttonWidth = 200.0
  static let buttonCornerRadius = 3.0
  static let buttonBackgroundColorForNormalState = 0x888888
  static let buttonBackgroundColorForHighlightedState = 0x777777
  static let buttonTitleColorForNormalState = 0xefefef
  static let buttonTitleColorForHighlightedState = 0xdedede
  static let buttonTitleFontSize = 22.0
  static let menuScrollViewHeightSmall = 110.0
  static let menuScrollViewHeightLarge = 130.0
  static let menuScrollViewCornerRadius = 3.0
  static let menuScrollViewBackgroundColor = 0x888888
  static let menuScrollViewSpacing = 15.0
  static let menuScrollViewInset = 15.0
  static let menuSliderTrackHeight = 5.0
  static let menuThumbSquareSideLength = 24.0
  static let menuThumbSquareBorderWidth = 6.0
  static let menuThumbSquareBorderColor = 0x777777
}

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
}

struct LogicConstant {
  static let defaultLevel = 5
  static let maximumLevel = 9
  static let minimumLevel = 2
  static let gameTitle = "Tower of Hanoi"
  static let pausedTitle = "Paused"
  static let winTitle = "You Win!"
  static let loseTitle = "You Lose..."
}

struct InfrastructureConstant {
  static let gameStateNotificationChannelName = "gameState"
  static let gameModeNotificationChannelName = "gameMode"
  static let gameLevelNotificationChannelName = "gameLevel"
}

struct UIConstant {
  static let maximumDiskHeight = 25.0
  static let largeSmallDiskWidthRatio = 3.0
  static let diskWidthOffset = 20.0
  static let diskHeightOffset = 12.0
  static let controlPanelHeight = 120.0
  static let rippleAnimatorTransitionDuration = 0.4
  static let buttonsVerticalSpacing = 10.0
  static let buttonsHorizontalSpacing = 20.0
  static let menuContentViewWidth = 220.0
  static let buttonHeight = 44.0
  static let buttonWidth = 200.0
  static let buttonCornerRadius = 3.0
  static let buttonBackgroundColorForNormalState = 0x888888
  static let buttonBackgroundColorForHighlightedState = 0x777777
  static let buttonTitleColorForNormalState = 0xefefef
  static let buttonTitleColorForHighlightedState = 0xdedede
  static let buttonTitleFontSize = 22.0
}

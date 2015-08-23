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

struct DiskConstant {
  static let maximumDiskHeight = 25.0
  static let largeSmallDiskWidthRatio = 3.0
  static let diskWidthOffset = 20.0
  static let diskHeightOffset = 12.0
}

struct LogicConstant {
  static let defaultLevel = 5
  static let maximumLevel = 9
  static let minimumLevel = 2
}

struct InfrastructureConstant {
  static let gameStateNotificationChannelName = "gameState"
  static let gameModeNotificationChannelName = "gameMode"
  static let gameLevelNotificationChannelName = "gameLevel"
}

struct UIConstant {
  static let controlPanelHeight = 120.0
  static let rippleAnimatorTransitionDuration = 0.4
}

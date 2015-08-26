//
//  GameLogic.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import Foundation

enum PoleType : Int {
  case OriginalPole
  case BufferPole
  case DestinationPole
  var description: String {
    switch self {
    case .OriginalPole:
      return "OriginalPole"
    case .BufferPole:
      return "BufferPole"
    case .DestinationPole:
      return "DestinationPole"
    }
  }
}

enum GameState: Hashable, Equatable {
  case Empty
  case Prepared
  case Started
  case Resumed
  case Paused
  case Ended(hasWon: Bool)
  var description: String {
    switch self {
    case .Empty:
      return "Empty"
    case .Prepared:
      return "Prepared"
    case .Started:
      return "Started"
    case .Resumed:
      return "Resumed"
    case .Paused:
      return "Paused"
    case let .Ended(hasWon):
      if hasWon {
        return "Won"
      } else {
        return "Lost"
      }
    }
  }
  var hashValue: Int {
    get {
      return self.description.hashValue
    }
  }
}
func ==(lhs:GameState, rhs:GameState) -> Bool {
  return lhs.description == rhs.description
}

enum GameMode {
  case Casual
  case Challenge
  var description: String {
    switch self {
    case .Casual:
      return "Casual"
    case .Challenge:
      return "Challenge"
    }
  }
}

class GameLogic: NSObject {
  
  static let defaultModel = GameLogic()
  
  private let gameStateNFA: [GameState:[GameState]] = {
    // Prepared -> Prepared holds in cases like adjusting game level
    let preparePrevStates = [GameState.Empty, GameState.Prepared, GameState.Ended(hasWon: true),
      GameState.Ended(hasWon: false), GameState.Paused]
    let startedPrevStates = [GameState.Prepared, GameState.Paused]
    let pausedPrevStates = [GameState.Started, GameState.Resumed]
    let resumedPrevStates = [GameState.Paused]
    let wonPrevStates = [GameState.Started, GameState.Resumed]
    let lostPrevStates = [GameState.Started, GameState.Resumed]
    return [GameState.Prepared:preparePrevStates, GameState.Started:startedPrevStates,
      GameState.Paused:pausedPrevStates, GameState.Resumed:resumedPrevStates,
      GameState.Ended(hasWon: true):wonPrevStates, GameState.Ended(hasWon: false):lostPrevStates]
    }() // state -> list of possible previous states
  
  var previousGameState = GameState.Empty
  
  var gameState: GameState = .Empty {
    willSet {
      previousGameState = gameState
    }
    didSet {
      if !validateState() {
        fatalError("Invalid state: \(previousGameState.description) state is not "
          + "a prior state to \(gameState.description) state.")
      }
      NSNotificationCenter.defaultCenter().postNotificationName(InfrastructureConstant.gameStateNotificationChannelName,
        object: self)
    }
  }
  
  var gameMode: GameMode = .Casual {
    didSet {
      NSNotificationCenter.defaultCenter().postNotificationName(InfrastructureConstant.gameModeNotificationChannelName,
        object: self)
    }
  }
  
  var gameLevel = LogicConstant.defaultLevel {
    didSet {
      if gameLevel < LogicConstant.minimumLevel {
        gameLevel = LogicConstant.minimumLevel
      }
      if gameLevel > LogicConstant.maximumLevel {
        gameLevel = LogicConstant.maximumLevel
      }
      NSNotificationCenter.defaultCenter().postNotificationName(InfrastructureConstant.gameLevelNotificationChannelName,
        object: nil)
    }
  }
  
  var poleStackForPoleType: [PoleType:[Disk]] = {
    return [.OriginalPole:[], .BufferPole:[], .DestinationPole:[]]
  }()
  
  lazy var operationStack : [(from: PoleType, to: PoleType)] = []
  
  private func validateState() -> Bool {
    if let prevStates = gameStateNFA[gameState] {
      return contains(prevStates, previousGameState)
    }
    return false
  }
  
  func createDisks(#largestDiskWidth: Double, numberOfDisks: Int, maximumDiskPileHeight: Double) -> [Disk] {
    let smallestDiskWidth = largestDiskWidth / UIConstant.largeSmallDiskWidthRatio
    if Double(numberOfDisks) * Disk.height > maximumDiskPileHeight - UIConstant.diskHeightOffset {
      Disk.height = (maximumDiskPileHeight - Disk.height) / Double(numberOfDisks)
    }
    let increment = (largestDiskWidth - smallestDiskWidth) / (Double(numberOfDisks - 1))
    var disks = [Disk]()
    for i in 0 ..< numberOfDisks {
      let disk = Disk(width: largestDiskWidth - Double(i) * increment)
      disks.append(disk)
    }
    return disks
  }
  
  func placeDisk(disk: Disk, onPole type: PoleType) {
    if let fromPole = disk.onPole {
      if fromPole != type {
        operationStack.append((from: fromPole, to: type))
      }
    }
    poleStackForPoleType[type]?.append(disk)
    disk.onPole = type
  }
  
  func removeDisk(disk: Disk) -> Disk? {
    if let onPole = disk.onPole {
      let removedDisk = poleStackForPoleType[onPole]?.removeLast()
      return removedDisk
    }
    return nil
  }
  
  func clearDisks() {
    poleStackForPoleType[.OriginalPole]?.removeAll(keepCapacity: false)
    poleStackForPoleType[.BufferPole]?.removeAll(keepCapacity: false)
    poleStackForPoleType[.DestinationPole]?.removeAll(keepCapacity: false)
    operationStack.removeAll(keepCapacity: false)
    println("originalPoleStack count: \(poleStackForPoleType[.OriginalPole]?.count)")
    println("bufferPoleStack count: \(poleStackForPoleType[.BufferPole]?.count)")
    println("destinationPoleStack count: \(poleStackForPoleType[.DestinationPole]?.count)")
    println("operationStack count: \(operationStack.count)")
  }
  
  func pileHeight(poleType type: PoleType) -> Double {
    if let stack = poleStackForPoleType[type] {
      return Double(stack.count) * Disk.height
    } else {
      return 0
    }
  }
  
  func shouldDiskMove(disk: Disk) -> Bool {
    if let type = disk.onPole {
      return poleStackForPoleType[type]?.last! === disk
    }
    return false
  }
  
  func shouldDiskPlaceToPole(#disk: Disk, pole: PoleType) -> Bool {
    if let topDisk = poleStackForPoleType[pole]?.last {
      return topDisk.width > disk.width
    }
    return true
  }
  
}

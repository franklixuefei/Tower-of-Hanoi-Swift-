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
  func description() -> String {
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

class GameLogic: NSObject {
  static let defaultModel = GameLogic()
  
  var poleStackForPoleType: [PoleType:[Disk]] = {
    var originalPoleStack = [Disk]()
    var bufferPoleStack = [Disk]()
    var destinationPoleStack = [Disk]()
    return [.OriginalPole:originalPoleStack, .BufferPole:bufferPoleStack, .DestinationPole:destinationPoleStack]
  }()
  
  func createDisks(#largestDiskWidth: Double, numberOfDisks: Int, maximumDiskPileHeight: Double) -> [Disk] {
    let smallestDiskWidth = largestDiskWidth / DiskConstant.largeSmallDiskWidthRatio
    if Double(numberOfDisks) * Disk.height > maximumDiskPileHeight - DiskConstant.diskHeightOffset {
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
  
  func pileHeight(poleType type: PoleType) -> Double {
    if let stack = poleStackForPoleType[type] {
      return Double(stack.count) * Disk.height
    } else {
      return 0
    }
  }
  
  func shouldDiskMove(disk: Disk) -> Bool {
    if let type = disk.onPole {
      return poleStackForPoleType[type]?.last! == disk
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

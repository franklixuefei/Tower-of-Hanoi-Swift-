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
  
  lazy var originalPoleStack = [Disk]()
  lazy var bufferPoleStack = [Disk]()
  lazy var destinationPoleStack = [Disk]()
  
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
    switch type {
    case .OriginalPole:
      originalPoleStack.append(disk)
    case .BufferPole:
      bufferPoleStack.append(disk)
    case .DestinationPole:
      destinationPoleStack.append(disk)
    }
    disk.onPole = type
  }
  
  func removeDisk(disk: Disk) -> Disk? {
    if let onPole = disk.onPole {
      let removedDisk: Disk
      switch onPole {
      case .OriginalPole:
        removedDisk = originalPoleStack.removeLast()
      case .BufferPole:
        removedDisk = bufferPoleStack.removeLast()
      case .DestinationPole:
        removedDisk = destinationPoleStack.removeLast()
      }
      return removedDisk
    }
    return nil
  }
  
  func pileHeight(poleType type: PoleType) -> Double {
    switch type {
    case .OriginalPole:
      return Double(originalPoleStack.count) * Disk.height
    case .BufferPole:
      return Double(bufferPoleStack.count) * Disk.height
    case .DestinationPole:
      return Double(destinationPoleStack.count) * Disk.height
    }
  }

}

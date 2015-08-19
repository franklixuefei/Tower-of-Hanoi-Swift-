//
//  GameLogic.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import Foundation

class GameLogic: NSObject {
  static let defaultModel = GameLogic()
  
  lazy var originalStack = [DiskParameter]()
  lazy var bufferStack = [DiskParameter]()
  lazy var destinationStack = [DiskParameter]()
  
  func createDisksData(#largestDiskWidth: Double, numberOfDisks: Int, maximumDiskPileHeight: Double) {
    let smallestDiskWidth = largestDiskWidth / DiskConstant.largeSmallDiskWidthRatio
    var diskHeight = DiskConstant.maximumDiskHeight
    if Double(numberOfDisks) * DiskConstant.maximumDiskHeight > maximumDiskPileHeight - DiskConstant.diskHeightOffset {
      diskHeight = (maximumDiskPileHeight - DiskConstant.diskHeightOffset) / Double(numberOfDisks)
    }
    let increment = (largestDiskWidth - smallestDiskWidth) / (Double(numberOfDisks - 1))
    for i in 0 ..< numberOfDisks {
      let disk = DiskParameter(width: largestDiskWidth - Double(i) * increment, height: diskHeight,
        onPole: .OriginalPole, distanceToPoleBase: Double(i) * diskHeight)
      originalStack.append(disk)
    }
  }

}

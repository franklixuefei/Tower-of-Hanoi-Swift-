//
//  Disk.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/20/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import Foundation

class Disk: NSObject {
  static var height = DiskConstant.maximumDiskHeight
  var width: Double
  var onPole: PoleType?
  init(width: Double) {
    self.width = width
  }
}

//
//  GameSceneView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class GameSceneView: UIView {
  
  @IBOutlet weak var originalPole: PoleView!
  @IBOutlet weak var bufferPole: PoleView!
  @IBOutlet weak var destinationPole: PoleView!
  
  func poleViewForPoleType(poleType: PoleType) -> PoleView {
    switch poleType {
    case .OriginalPole:
      return originalPole
    case .BufferPole:
      return bufferPole
    case .DestinationPole:
      return destinationPole
    }
  }
}

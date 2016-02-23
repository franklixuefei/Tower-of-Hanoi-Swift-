//
//  GameSceneView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class GameSceneView: UIView {
  
  @IBOutlet weak var originalPoleContainer: PoleViewContainer!
  @IBOutlet weak var bufferPoleContainer: PoleViewContainer!
  @IBOutlet weak var destinationPoleContainer: PoleViewContainer!
  
  func poleViewForPoleType(poleType: PoleType) -> PoleView {
    switch poleType {
    case .OriginalPole:
      return originalPoleContainer.poleView
    case .BufferPole:
      return bufferPoleContainer.poleView
    case .DestinationPole:
      return destinationPoleContainer.poleView
    }
  }
}

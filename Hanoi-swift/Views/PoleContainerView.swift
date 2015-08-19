
//
//  PoleContainerView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class PoleContainerView: UIView {

  enum PoleType {
    case OriginalPole
    case BufferPole
    case DestinationPole
  }
  
  var poleType: PoleType!
  
}

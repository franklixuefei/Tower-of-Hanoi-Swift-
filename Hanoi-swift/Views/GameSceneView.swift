//
//  GameSceneView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class GameSceneView: UIView {
  
  @IBOutlet weak var firstPoleContainer: UIView! {
    didSet {
      let pole = instantiatePole(poleType: .OriginalPole)
      pinPoleToContainer(pole);
    }
  }
  @IBOutlet weak var secondPoleContainer: UIView! {
    didSet {
      let pole = instantiatePole(poleType: .BufferPole)
      pinPoleToContainer(pole);
    }
  }
  @IBOutlet weak var thirdPoleContainer: UIView! {
    didSet {
      let pole = instantiatePole(poleType: .DestinationPole)
      pinPoleToContainer(pole);
    }
  }
  
  private func instantiatePole(poleType type:PoleContainerView.PoleType) -> PoleContainerView {
    let pole = UIView.viewFromNib("PoleContainerView") as! PoleContainerView
    pole.poleType = type
    return pole;
  }
  
  private func pinPoleToContainer(pole: PoleContainerView) {
    let poleContainer: UIView!
    switch pole.poleType! {
    case .OriginalPole:
      poleContainer = firstPoleContainer
    case .BufferPole:
      poleContainer = secondPoleContainer
    case .DestinationPole:
      poleContainer = thirdPoleContainer
    default:
      break
    }
    poleContainer.addSubview(pole)
    pole.setTranslatesAutoresizingMaskIntoConstraints(false)
    let viewsDict = ["pole": pole]
    poleContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[pole]|", options: nil, metrics: nil, views: viewsDict))
    poleContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[pole]|", options: nil, metrics: nil, views: viewsDict))
  }

}

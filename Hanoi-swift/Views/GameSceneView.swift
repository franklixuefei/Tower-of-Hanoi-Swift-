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
      instantiatePole(poleType: .OriginalPole)
      pinPoleToContainer(originalPole);
    }
  }
  @IBOutlet weak var secondPoleContainer: UIView! {
    didSet {
      instantiatePole(poleType: .BufferPole)
      pinPoleToContainer(bufferPole);
    }
  }
  @IBOutlet weak var thirdPoleContainer: UIView! {
    didSet {
      instantiatePole(poleType: .DestinationPole)
      pinPoleToContainer(destinationPole);
    }
  }
  
  var originalPole: PoleView!
  var bufferPole: PoleView!
  var destinationPole: PoleView!
  
  private func instantiatePole(poleType type:PoleView.PoleType) {
    let pole = UIView.viewFromNib(XibNames.PoleContainerViewXibName) as! PoleView
    pole.poleType = type
    switch type {
    case .OriginalPole:
      originalPole = pole
    case .BufferPole:
      bufferPole = pole
    case .DestinationPole:
      destinationPole = pole
    }
  }
  
  private func pinPoleToContainer(pole: PoleView) {
    let poleContainer: UIView!
    switch pole.poleType! {
    case .OriginalPole:
      poleContainer = firstPoleContainer
    case .BufferPole:
      poleContainer = secondPoleContainer
    case .DestinationPole:
      poleContainer = thirdPoleContainer
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

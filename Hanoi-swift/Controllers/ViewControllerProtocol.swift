//
//  ViewControllerProtocol.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/20/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

protocol ViewControllerProtocol {
  var dotButton: ControlPanelButton! { get set }
  func dotPressed()
}

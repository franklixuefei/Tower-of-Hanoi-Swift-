//
//  MenuView.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/20/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuView: UIView {
  @IBOutlet weak var gameTitle: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    gameTitle.font = UIFont(name: "LucidaHandwriting-Italic", size: 45)
  }
  
}

//
//  MenuSlider.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/29/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

class MenuSlider: UISlider {
  
  override func trackRectForBounds(bounds: CGRect) -> CGRect {
    let trackHeight = CGFloat(UIConstant.menuSliderTrackHeight)
    let y =  (bounds.height - trackHeight) / 2.0
    return CGRect(x: 0, y: y, width: bounds.width, height: trackHeight)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    self.setMinimumTrackImage(UIImage.imageWithColor(UIColor.whiteColor()), forState: .Normal)
    self.setMaximumTrackImage(UIImage.imageWithColor(UIColor.whiteColor()), forState: .Normal)
    let thumbSize = CGFloat(UIConstant.menuThumbSquareSideLength)
    let thumbBorderWidth = CGFloat(UIConstant.menuThumbSquareBorderWidth)
    let thumbBorderColor = UIColor.color(hexValue: UInt(UIConstant.menuThumbSquareBorderColor), alpha: 1)
    self.setThumbImage(UIImage.imageWithBorderRectangle(CGSize(width: thumbSize, height: thumbSize),
      borderWidth: thumbBorderWidth, borderColor: thumbBorderColor, fillColor: UIColor.whiteColor()),
      forState: .Normal)
  }

}

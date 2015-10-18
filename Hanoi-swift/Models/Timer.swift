//
//  Timer.swift
//  Hanoi-swift
//
//  Created by Frank Li on 10/17/15.
//  Copyright © 2015 Frank Li. All rights reserved.
//

import Foundation

class Timer {
  var hour:Int!
  var minute:Int!
  var second:Int!
  var boundaryReached = false
  
  func invalidate(countUp countUp:Bool, level:Int) {
    if countUp {
      hour = 0
      minute = 0
      second = 0
    } else {
      (hour, minute, second) = initialTimeForLevel(level)
    }
  }
  
  func increment() -> Bool {
    if second == LogicConstant.secondBase-1
      && minute == LogicConstant.minuteBase-1
      && hour == LogicConstant.timerHourUpperBound {
        return false
    }
    second = second + 1
    let minuteCarry = second / LogicConstant.secondBase
    second = second % LogicConstant.secondBase
    minute = minute + minuteCarry
    let hourCarry = minute / LogicConstant.minuteBase
    minute = minute % LogicConstant.minuteBase
    hour = hour + hourCarry
    return true
  }
  
  func decrement() -> Bool {
    if second == 0 && minute == 0 && hour == 0 {
      return false
    }
    second = second - 1
    if second < 0 {
      second = second + LogicConstant.secondBase
      minute = minute - 1
      if minute < 0 {
        minute = minute + LogicConstant.minuteBase
        hour = hour - 1
      }
    }
    return true
  }
  
  func toString() -> String {
    if hour == 0 {
      return String(format: "%02d:%02d", minute, second)
    } else {
      return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
  }
  
  private func initialTimeForLevel(level:Int) -> (Int!, Int!, Int!) {
    // TODO: decide the initial time for each level.
    return (0,0,5)
  }
}

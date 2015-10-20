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
  
  var timeElapsedInSeconds = 0
  
  func invalidate(countUp countUp:Bool, level:Int) {
    if countUp {
      hour = 0
      minute = 0
      second = 0
    } else {
      initiateChallengeTimeForLevel(level)
    }
    timeElapsedInSeconds = 0
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
    timeElapsedInSeconds++
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
    timeElapsedInSeconds++
    return true
  }
  
  func toString() -> String {
    if hour == 0 {
      return String(format: "%02d:%02d", minute, second)
    } else {
      return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
  }
  
  private func initiateChallengeTimeForLevel(level:Int) {
    var factor:Double
    switch level {
    case 2:
      factor = 1.2
    case 3:
      factor = 1.25
    case 4:
      factor = 1.3
    case 5:
      factor = 1.45
    case 6:
      factor = 1.6
    case 7:
      factor = 1.75
    case 8:
      factor = 1.9
    case 9:
      factor = 2.1
    default:
      factor = 999.0
    }
    let seconds = pow(2.0, Double(level)) * factor
    second = Int(round(seconds)) % LogicConstant.secondBase
    minute = Int(round(seconds)) / LogicConstant.secondBase
    hour = minute / LogicConstant.minuteBase
    minute = minute % LogicConstant.minuteBase
  }
}

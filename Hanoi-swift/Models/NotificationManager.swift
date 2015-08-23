//
//  NotificationManager.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/23/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import Foundation

class NotificationManager {
  static let defaultManager = NotificationManager()
  lazy private var observerTokens: [AnyObject] = []
  lazy private var operationQueue: NSOperationQueue = {
    var queue = NSOperationQueue()
    queue.name = "Block Queue"
    return queue
  }()
  
  deinit {
    deregisterAll()
  }
  
  private func deregisterAll() {
    for token in observerTokens {
      NSNotificationCenter.defaultCenter().removeObserver(token)
    }
    observerTokens = []
  }
  
  func registerObserver(name: String!, block: (NSNotification!) -> Void) {
    let newToken = NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: operationQueue) {
      note in block(note)
    }
    
    observerTokens.append(newToken)
  }
  
  func registerObserver(name: String!, forObject object: AnyObject!, block: (NSNotification!) -> Void) {
    let newToken = NSNotificationCenter.defaultCenter().addObserverForName(name, object: object, queue: operationQueue)
      {note in block(note)}
    
    observerTokens.append(newToken)
  }
}

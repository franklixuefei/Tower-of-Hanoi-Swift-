//
//  AppDelegate.swift
//  Hanoi-swift
//
//  Created by Frank Li on 8/16/15.
//  Copyright (c) 2015 Frank Li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var gameViewController: GameViewController?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
    -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.backgroundColor = UIColor.whiteColor()
    window?.makeKeyAndVisible()
    gameViewController = GameViewController()
    window?.rootViewController = gameViewController
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    gameViewController?.dotPressed()
  }

  func applicationWillTerminate(application: UIApplication) {
    // TODO: Save the current status
  }

}

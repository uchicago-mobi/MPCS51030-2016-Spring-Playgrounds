//
//  InterfaceController.swift
//  instaWatchApp Extension
//
//  Created by T. Andrew Binkowski on 5/17/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
  /// Connectivity session
  let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    print("awakeWithContext: \(context)")
  }
  
  override init() {
    super.init()
    session?.delegate = self
    session?.activateSession()
  }
  
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
     print("activate")
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
}

extension InterfaceController: WCSessionDelegate {
  
  /// Handle application context sent from the iOS app
  func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
    NSLog("didReceiveApplicationContext: \(applicationContext)")
    dispatch_async(dispatch_get_main_queue()) {
      // self.nameLabel.setText(applicationContext["text"] as? String)
    }
    WKInterfaceDevice.currentDevice().playHaptic(.Notification)
  }
  
  func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
    NSLog("didReceiveMessage: \(message)")
    dispatch_async(dispatch_get_main_queue()) {
      //self.nameLabel.setText(message["text"] as? String)
    }
    WKInterfaceDevice.currentDevice().playHaptic(.Notification)
  }
}

//
//  InterfaceController.swift
//  InterFaces WatchKit Extension
//
//  Created by T. Andrew Binkowski on 4/29/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
  
  /// The label we will update from iOS
  @IBOutlet var nameLabel: WKInterfaceLabel!
  
  /// Connectivity session
  let session = WCSession.defaultSession()
  
  
  //
  // MARK: - IBActions
  //
  
  @IBAction func tapToInteractive() {
    print("Tap (interactive)")
    let applicationDict = ["text":"Hi from interactive Watch message."]
    WCSession.defaultSession().sendMessage(applicationDict, replyHandler: { (reply) in
      print("Reply: \(reply)")
      
    }) { (error) in
      print("Error: \(error)")
    }
    
  }
  
  @IBAction func tapToApplicationContext() {
    print("Tap (application context")
    do {
      let applicationDict = ["text":"Hi from Watch Application Context."]
      try WCSession.defaultSession().updateApplicationContext(applicationDict)
    } catch {
      // Handle errors here
      print(error)
    }
    
  }
  
  
  //
  // MARK: - Lifecycle
  //
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    // Configure interface objects here.
    if (WCSession.isSupported()) {
      session.delegate = self
      session.activateSession()
    }
    print("awakeWithContext: \(context)")
    nameLabel.setText("")
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
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
      self.nameLabel.setText(applicationContext["text"] as? String)
    }
    WKInterfaceDevice.currentDevice().playHaptic(.Notification)
  }
  
  func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
    NSLog("didReceiveMessage: \(message)")
    dispatch_async(dispatch_get_main_queue()) {
      self.nameLabel.setText(message["text"] as? String)
    }
    WKInterfaceDevice.currentDevice().playHaptic(.Notification)
  }
  
}

//
//  NotificationController.swift
//  WatchThis WatchKit Extension
//
//  Created by T. Andrew Binkowski on 5/1/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import WatchKit
import Foundation


class NotificationController: WKUserNotificationInterfaceController {
  
  @IBOutlet var messageLabel: WKInterfaceLabel!
  @IBOutlet var faceImage: WKInterfaceImage!
  
  override init() {
    // Initialize variables here.
    super.init()
    
    // Configure interface objects here.
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  
  override func didReceiveLocalNotification(localNotification: UILocalNotification, withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
    // This method is called when a local notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    print("Received Local Notification: \(localNotification)")
    
    completionHandler(.Custom)
  }
  
  
  override func didReceiveRemoteNotification(remoteNotification: [NSObject : AnyObject], withCompletion completionHandler: ((WKUserNotificationInterfaceType) -> Void)) {
    // This method is called when a remote notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.
    //
    // After populating your dynamic notification interface call the completion block.
    let message = remoteNotification["aps"]!["alert"]!!["body"] as? String
    messageLabel.setText(message)
    print("Received Remote Notification: \(remoteNotification)")
    completionHandler(.Custom)
  }
  
}

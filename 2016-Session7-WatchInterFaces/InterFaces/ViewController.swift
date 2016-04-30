//
//  ViewController.swift
//  InterFaces
//
//  Created by T. Andrew Binkowski on 4/29/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit
import WatchConnectivity


class ViewController: UIViewController {
  
  /// A button that sends a dictionary to the watch app using application
  /// context.  Only the latest message send through application context is
  /// delivered to the watch.
  @IBAction func tapSendToWatch(sender: UIButton) {
    
    do {
      let applicationDict = ["data":"This is data"]
      try WCSession.defaultSession().updateApplicationContext(applicationDict)
      NSLog("tap")
    } catch {
      NSLog("tap error")
      // Handle errors here
    }
  }
  
  
  /// Tap button that sends a dictionary to the watch app in an interactive
  /// pattern.
  @IBAction func tapSendToWatchInteractive(sender: UIButton) {
    
    guard WCSession.defaultSession().reachable else { return }
    let applicationDict = ["text":"Hi from interactive iOS message."]
    WCSession.defaultSession().sendMessage(applicationDict, replyHandler: { (reply) in
      print("Reply: \(reply)")
    }) { (error) in
      print("Error: \(error)")
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  
}



//
//  SecondViewController.swift
//  instaWatchItOnTv
//
//  Created by T. Andrew Binkowski on 5/7/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit
import WatchConnectivity

class SecondViewController: UIViewController {
  
  
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
   print("Hi")
//     guard WCSession.defaultSession().reachable else {
//      return
//    }
    let applicationDict = ["text":"Hi from interactive iOS message."]
    WCSession.defaultSession().sendMessage(applicationDict, replyHandler: { (reply) in
      print("Reply: \(reply)")
    }) { (error) in
      print("Error: \(error)")
    }
  
    do {
      let applicationDict = ["data":"This is data"]
      try WCSession.defaultSession().updateApplicationContext(applicationDict)
      NSLog("tap")
    } catch {
      let alertController = UIAlertController(title: "Oops!", message: "Looks like your got stuck on the way! Please send again!", preferredStyle: .Alert)
      presentViewController(alertController, animated: true, completion: nil)
    }
    
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}


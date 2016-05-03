//
//  InterfaceController.swift
//  WatchThis WatchKit Extension
//
//  Created by T. Andrew Binkowski on 5/1/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import WatchKit
import Foundation
import WatchInterfaceKit

class InterfaceController: WKInterfaceController {
  
  /// Array of Face objects of executives
  let faces = Faces().list
  
  //
  // MARK: - Outlets and Actions
  //
  @IBOutlet weak var headerLabel: WKInterfaceLabel!
  @IBOutlet weak var table: WKInterfaceTable!
  
  /// From a force touch, reset the favorite
  @IBAction func tapMenuTrash() {
    print("Tap Menu Trash")
    LocalDefaultsManager.sharedInstance.reset()
  }
  
  //
  // MARK: - Lifecycle
  //
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    // Configure interface objects here
    self.headerLabel.setText("Apple Executives")
    
    // Send work to parent.  This is just to show how to do it, we aren't
    // actually doing any work related to our app's function
    //parentDoWork()
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    
    // Load up the table
    reloadTable()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  //
  // MARK: - Notifications
  //
  
  override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
    if let notificationIdentifier = identifier {
      if notificationIdentifier == "firstButtonAction" {
        print("You tapped the first button on the notificaiton and passed it to the interface Controller")
      }
    }
  }
  
  //
  // MARK: - Handoff Support
  //
  
  /// Called when the Watch App gets launched from a Glance
  override func handleUserActivity(userInfo: [NSObject : AnyObject]?) {
    print("Launch from Glance: \(userInfo)")
    let nameOfFavorite = userInfo!["currentFavorite"] as! String
    pushControllerWithName("FaceDetailController",context: nameOfFavorite)
  }
  
  
  //
  // MARK: - Table Support
  //
  func reloadTable() {
    table.setNumberOfRows(faces.count, withRowType: "FaceRow")
    
    // Go through our array of people and fill in the table
    for (index, face) in (faces).enumerate() {
      if let row = table.rowControllerAtIndex(index) as? FaceRow {
        // Get the current face from the index
        let currentFace = faces[index]
        
        // Set the interface objects
        row.titleLabel.setText(currentFace.title)
        row.nameLabel.setText(currentFace.name)
        row.image.setImageNamed(currentFace.imageName)
      }
    }
  }
  
  // MARK: - Segue
  override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
    // Validate which segue we are triggering
    if segueIdentifier == "FaceDetailSegue" {
      // Get face from row index and return (to be used as context in
      // segue
      let name = faces[rowIndex].name
      return name
    }
    // Return nil as a fallback
    return nil
  }
  
  // MARK: - Parent Work
  /**
   This function is an example of how you would request the parent app to
   do some work and return a reply.  This is not used for
   */
  //  func parentDoWork() {
  //    WKInterfaceController.openParentApplication(["request": "refreshData"], reply: { (replyInfo, error) -> Void in
  //      if let newData = replyInfo["executiveData"] as? String {
  //        print("New Data: \(newData)")
  //      }
  //    })
  //  }
}

//
//  ViewController.swift
//  2016-CoreDataStack
//
//  Created by T. Andrew Binkowski on 4/10/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  
  
  // For this implementation, the Core Data stack is in the AppDelegate (the
  // most singlety singleton of them all).  For convienence, let's keep a
  // refernce to it
  let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create a user, "Homer"
    let user1 = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: (delegate?.managedObjectContext)!) as? User
    user1?.name = "Homer"
    user1?.gender = "Male"
    
    // Create a user "Marge", but more Swifty
    guard let user2 = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: (delegate?.managedObjectContext)!) as? User else {
      return
    }
    user2.name = "Marge"
    user2.gender = "Female"
    
    // Create a user "Marge", but more Swifty
    guard let user3 = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: (delegate?.managedObjectContext)!) as? User else {
      return
    }
    user3.name = "Lisa"
    user3.gender = "Female"
    
    
    // Let's create a bunch sessesions and add them to difference users
    for i in 0...10 {
      
      var session = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext: (delegate?.managedObjectContext)!) as? Session
      if let session = session {
        // Just for fun, make the even sessions true
        session.active = (i % 2 == 0) ? true : false
        session.timestamp = NSDate()
        session.user = user1
      }
      
      // Add some for Marge
      session = NSEntityDescription.insertNewObjectForEntityForName("Session", inManagedObjectContext: (delegate?.managedObjectContext)!) as? Session
      if let session = session {
        // Just for fun, make the even sessions true
        session.active = (i % 2 == 0) ? true : false
        session.timestamp = NSDate()
        session.user = user2
      }
      
      // The objects are only in memory until we save them
      //delegate?.saveContext()
      
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Assuming type has a reference to managed object context
    let fetchRequest = NSFetchRequest(entityName: "User")
    do {
      let fetchedEntities = try delegate?.managedObjectContext.executeFetchRequest(fetchRequest) as? [User]
     
       for user in fetchedEntities! {
        print("######################################## \(user.name!) ##########")
        for session in user.sessions! {
          print(session)
        }
      }
      
    } catch {
      // Do something in response to error condition
    }
  }
  
}


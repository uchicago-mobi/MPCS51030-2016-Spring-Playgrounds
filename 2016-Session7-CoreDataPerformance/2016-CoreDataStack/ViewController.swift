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
    
    // Let's create a bunch sessesions and add them to difference users
    for i in 0...1 {
      print(i)
      
      // Create a user "Marge", but more Swifty
      guard let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: (delegate?.managedObjectContext)!) as? User else {
        return
      }
      user.name = "Item \(i)"
      user.image = UIImagePNGRepresentation(UIImage(named: "Logo")!)
      
      // Create an image for out Cache
      //let logo = NSEntityDescription.insertNewObjectForEntityForName("ImageCache", inManagedObjectContext: (delegate?.managedObjectContext)!) as? ImageCache
      //logo?.imageData = UIImagePNGRepresentation(UIImage(named: "Logo")!)
      //logo?.timestamp = NSDate()
      
      // The objects are only in memory until we save them
      //delegate?.saveContext()
      
    }
    delegate?.saveContext()
    
    
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


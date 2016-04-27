//
//  CoreDataManager.swift
//  CloudDataSync
//
//  Created by T. Andrew Binkowski on 4/19/15.
//  Copyright (c) 2015 The University of Chicago. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataManager: NSObject {
  
  /// Singleton variable
  public static let sharedInstance = CoreDataManager()
  
  /// iCloudOptions should be nil for local Documents based Core Data store
  /// For a local store we could reuse this code as:
  /// `let iCloudOptions: Dictionary<NSObject, AnyObject>? = nil`
  let iCloudOptions: Dictionary<NSObject, AnyObject>? = {
    [NSPersistentStoreUbiquitousContentNameKey: "iCloudDataSync"]
  }()
  
  /// The directory the application uses to store the Core Data store file
  public lazy var applicationDocumentsDirectory: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.count-1]
  }()
  
  /// The managed object model for the application. This property is not
  /// optional. It is a fatal error for the application not to be able to find
  /// and load its model.
  public lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = NSBundle.mainBundle().URLForResource("CloudDataSync", withExtension: "momd")!
    return NSManagedObjectModel(contentsOfURL: modelURL)!
  }()
  
  /// Persistant store (with code for both iCloud and not iCloud setup)
  public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
    var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    
    // Create the "Default" store, in this case the `Application`s inside of 
    // application documents directory
    // let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CloudDataSync.sqlite")
    // println("CoreData URL: \(url)")
    
    // Create the directory using App Groups so that the data can be accessed by
    // an extension
    let sharedAppGroup: String = "group.mobi.uchicago.cloudDataSync"
    var sharedContainerURL: NSURL? = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(sharedAppGroup)
    let url = sharedContainerURL!.URLByAppendingPathComponent("CloudDataSync.sqlite")
    print("App Group URL: \(url)")
    
    // Add the 'Default' persistant store
    var error: NSError? = nil
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options:  [NSPersistentStoreUbiquitousContentNameKey: "iCloudDataSync"])
    } catch var error1 as NSError {
      error = error1
      coordinator = nil
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
      dict[NSLocalizedFailureReasonErrorKey] = failureReason
      dict[NSUnderlyingErrorKey] = error
      error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      // Replace this with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog("Unresolved error \(error), \(error!.userInfo)")
      abort()
    } catch {
      fatalError()
    }
    
    // Create the image cache persistant store defined as a separate "Configuration"
    let imageCacheURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("ImageCache.sqlite")
    print("ImageCache URL: \(url)")
    do {
      try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: "ImageCache", URL: imageCacheURL, options: nil)
    } catch var error1 as NSError {
      error = error1
      print("Image Cache store problem")
      abort()
    } catch {
      fatalError()
    }
    
    return coordinator
  }()
  
  /// Returns the managed object context for the application (which is already
  /// bound to the persistent store coordinator for the application.) This 
  /// property is optional since there are legitimate error conditions that 
  /// could cause the creation of the context to fail. */
  public lazy var managedObjectContext: NSManagedObjectContext? = {
    let coordinator = self.persistentStoreCoordinator
    if coordinator == nil {
      return nil
    }
    var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return managedObjectContext
  }()
  
  //
  // MARK: - Core Data Saving support
  //
  public func saveContext () {
    if let moc = self.managedObjectContext {
      var error: NSError? = nil
      if moc.hasChanges {
        do {
          try moc.save()
        } catch let error1 as NSError {
          error = error1
          // Replace this implementation with code to handle the error appropriately.
          // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
          NSLog("Unresolved error \(error), \(error!.userInfo)")
          abort()
        }
      }
    }
  }
  
  
  // MARK: - Core Data iCloud
  /**
   Set iCloud notificaiton subscriptions
   
   - parameter persistenStoreCoordinator: The store coordinator that will be monitored
   */
  public func observeCloudActions(persistentStoreCoordinator psc: NSPersistentStoreCoordinator?) {
    let nc = NSNotificationCenter.defaultCenter();
    nc.addObserver(self, selector: #selector(CoreDataManager.storesWillChange(_:)), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: psc);
    nc.addObserver(self, selector: #selector(CoreDataManager.storesDidChange(_:)), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: psc);
    nc.addObserver(self, selector: #selector(CoreDataManager.persistentStoreDidImportUbiquitousContentChanges(_:)), name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: psc);
    nc.addObserver(self, selector: Selector("mergeChanges:"), name: NSManagedObjectContextDidSaveNotification, object: psc);
  }
  

  public func storesWillChange(notification: NSNotification) {
    /*
    NSLog("storesWillChange notif:\(notification)");
    if let moc = self.managedObjectContext {
      moc.performBlockAndWait {
        var error: NSError? = nil;
        //if moc.hasChanges && 
        do {
          try moc.save() {
          NSLog("Save error: \(error)");
        } catch {
          // drop any managed objects
        }
        
        // Reset context anyway, as suggested by Apple Support
        // The reason is that when storesWillChange notification occurs, Core Data is going to switch the stores. During and after that switch (happening in background), your currently fetched objects will become invalid.
        
        moc.reset();
      }
      // now reset your UI to be prepared for a totally different
      // set of data (eg, popToRootViewControllerAnimated:)
      // BUT don't load any new data yet.
    }
    */
  }

  public func storesDidChange(notification: NSNotification) {
    // here is when you can refresh your UI and load new data from the new store
    NSLog("storesDidChange posting notif");
    //self.postRefetchDatabaseNotification();
  }
  
  public func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification) {
    NSLog("mergeChanges notif:\(notification)")
    if let moc = managedObjectContext {
      moc.performBlock {
        moc.mergeChangesFromContextDidSaveNotification(notification)
        //self.postRefetchDatabaseNotification()
      }
    }
  }
  
}

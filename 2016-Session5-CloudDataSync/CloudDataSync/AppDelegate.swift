//
//  AppDelegate.swift
//  CloudDataSync
//
//  Created by T. Andrew Binkowski on 4/19/15.
//  Copyright (c) 2015 The University of Chicago. All rights reserved.
//

import UIKit
import CoreData
import DataKit
import CloudKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    if let notification:UILocalNotification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
      print("Launch from local notification: \(notification)")
    }
    
    //
    let settings = UIUserNotificationSettings(forTypes: [.Alert,.Badge,.Sound], categories: nil)
    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications() // only need this for background modes
    cloudKitSubscriptions()
    
    CloudKitManager.sharedInstance.sync { (results) -> Void in
      print("CloudKit Results: \(results)")
    }
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
  }
  
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    
    let cloudKitNotification = CKNotification(fromRemoteNotificationDictionary: userInfo as! [String : NSObject])
    print("CloudKit Notification: \(cloudKitNotification)")
    if cloudKitNotification.notificationType == .Query {
      let queryNotification = cloudKitNotification as! CKQueryNotification
      if queryNotification.queryNotificationReason == .RecordDeleted {
        // If the record has been deleted in CloudKit then delete the local copy here
      } else {
        // If the record has been created or changed, we fetch the data from CloudKit
        /*
         let database: CKDatabase
         if queryNotification.isPublicDatabase {
         database = CKContainer.defaultContainer().publicCloudDatabase
         } else {
         database = CKContainer.defaultContainer().privateCloudDatabase
         }
         database.fetchRecordWithID(queryNotification.recordID!, completionHandler: { (record: CKRecord?, error: NSError?) -> Void in
         guard error == nil else {
         // Handle the error here
         return
         }
         
         if queryNotification.queryNotificationReason == .RecordUpdated {
         // Use the information in the record object to modify your local data
         } else {
         // Use the information in the record object to create a new local object
         }
         })
         */
      }
    }
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                   fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    // Do stuff
    print("Received Push notification: \(userInfo)")
    showAlertForNotification(userInfo)
    completionHandler(UIBackgroundFetchResult.NoData)
  }
  
  
  ///
  /// Subscribe to CloudKit notifications
  func cloudKitSubscriptions() {
    
    let predicate = NSPredicate(format: "TRUEPREDICATE")
    let subscription = CKSubscription(recordType: "Favorite", predicate: predicate,
                                      options: [.FiresOnRecordCreation, .FiresOnRecordUpdate, .FiresOnRecordDeletion])
    let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
    let notification = CKNotificationInfo()
    notification.alertBody = "There's a great new timestamp for you to read."
    notification.soundName = UILocalNotificationDefaultSoundName
    subscription.notificationInfo = notification
    
    publicDatabase.saveSubscription(subscription) { (subscription: CKSubscription?, error: NSError?) -> Void in
      guard error == nil else {
        print(error)
        return
      }
      // TODO: Save that we have subscribed successfully to keep track and avoid trying to subscribe again
    }

  }
  
  //
  // MARK: - Notifications Support
  //
  
  /// Create an alert to show if the application is active and receives a local
  /// notification
  /// - parameter notification: The `UILocalNotification` received
  func showAlertForNotification(userInfo: [NSObject : AnyObject]) {
    
    // Do not show unless the application is active
    guard UIApplication.sharedApplication().applicationState == .Active else { return }
    
    // Create the alert
    let alertController = UIAlertController(title: "Recieved Notification",
                                            message: userInfo.description,
                                            preferredStyle: .Alert)
    
    // Create cancel action that does nothing
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    // Show the alert and exit early
    self.window?.rootViewController?.presentViewController(alertController,
                                                           animated: true,
                                                           completion: nil)
    //let vc = window?.rootViewController as? ViewController
    //vc?.refreshTable()
  }
  
  /// Alternative (more flexible way)
  func showNotificationNowFromCloudKit(notification: UILocalNotification) {
    //  Create a notofication
    let notification = UILocalNotification()
    notification.alertBody = "This was from a Now notification."
    notification.alertAction = "Ok!"
    
    // Schedule the notification
    UIApplication.sharedApplication().presentLocalNotificationNow(notification)
  }
  
}


extension UIColor {
  class func randomColor(hue:CGFloat? = ( CGFloat( CGFloat(arc4random()) % 256 / 256.0 ) ),
                         saturation:CGFloat? = ( CGFloat( CGFloat(arc4random()) % 128 / 256.0 ) + 0.5 ),
                         brightness:CGFloat? = ( CGFloat( CGFloat(arc4random()) % 128 / 256.0 ) + 0.5 ),
                         alpha:CGFloat? = CGFloat(1.0)) -> UIColor {
    return UIColor(hue: hue!, saturation: saturation!, brightness: brightness!, alpha: alpha!);
  }
}



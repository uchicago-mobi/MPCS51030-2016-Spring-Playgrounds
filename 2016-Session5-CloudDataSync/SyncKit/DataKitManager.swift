//
//  DataKitManager.swift
//  CloudDataSync
//
//  Created by T. Andrew Binkowski on 4/19/15.
//  Copyright (c) 2015 The University of Chicago. All rights reserved.
//

import Foundation
import CloudKit

/** To enable extension data sharing, we need to use an app group */
let sharedAppGroup: String = "group.mobi.uchicago.cloudDataSync"

/** The key for our defaults storage */
let favoritesKey: String = "Favorites"




//
// MARK: - ClouldKitManager
//

/**
 CloudKitManager
 Store in CloudKit and sync with NSUserDefauls in app group
 */
public class CloudKitManager {
  public static let sharedInstance = CloudKitManager()
  
  
  let sharedDefaults: NSUserDefaults?
  var favorites: NSMutableArray?
  
  var container : CKContainer
  var publicDB : CKDatabase
  let privateDB : CKDatabase
  
  init() {
    sharedDefaults = NSUserDefaults(suiteName: sharedAppGroup)
    print(sharedDefaults?.dictionaryRepresentation())
    container = CKContainer.defaultContainer()
    publicDB = container.publicCloudDatabase
    privateDB = container.privateCloudDatabase
  }
  
  public func add(object anObject: NSObject, callback:((record: CKRecord?, success: Bool) -> ())?) {
    
    // Update local list in user defaults
    let current: NSMutableArray = currentList()
    current.addObject(anObject)
    sharedDefaults?.setObject(current, forKey: favoritesKey)
    sharedDefaults?.synchronize()
    
    // Save to ClouldKit
    let record = CKRecord(recordType: "Favorite")
    record.setValue(anObject, forKey: "Name")
    publicDB.saveRecord(record, completionHandler: { (record, error) -> Void in
      if error != nil {
        if error!.code == CKErrorCode.PartialFailure.rawValue {
          print("There was a problem completing the operation. The following records had problems: \(error!.userInfo[CKPartialErrorsByItemIDKey])")
        }
        dispatch_async(dispatch_get_main_queue()) {
          callback?(record: record, success: false)
        }
      } else {
        NSLog("Saved to cloud kit")
        dispatch_async(dispatch_get_main_queue()) {
          callback?(record: record, success: true)
        }
      }
      
      
    })
    
    
  }
  
  /// Delete all the records that are passed in.  This is for debugging and
  /// development only in this application.
  ///
  /// - Note: You must enable `Write` access to the authenticated user for this
  ///         to work.  You will get permission error any other way
  public func deleteList(records: [CKRecordID], callback:((success: Bool) -> ())?) {
    let updateOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: records)
    
    updateOperation.perRecordCompletionBlock = { record, error in
      if error != nil {
        // Really important to handle this here
        print("Unable to modify record: \(record). Error: \(error)")
      }
    }
    updateOperation.modifyRecordsCompletionBlock = { saved, _, error in
      if error != nil {
        if error!.code == CKErrorCode.PartialFailure.rawValue {
          print("There was a problem completing the operation. The following records had problems: \(error!.userInfo[CKPartialErrorsByItemIDKey])")
        }
        
        dispatch_async(dispatch_get_main_queue()) {
          callback?(success: false)
        }
      } else {
        dispatch_async(dispatch_get_main_queue()) {
          callback?(success: true)
        }
      }
    }
    publicDB.addOperation(updateOperation)
  }
  
  
  public func currentList() -> NSMutableArray {
    var current: NSMutableArray = []
    if let tempNames: NSArray = sharedDefaults?.arrayForKey(favoritesKey) {
      current = tempNames.mutableCopy() as! NSMutableArray
    }
    return current
  }
  
  public func reset() {
    sharedDefaults?.setObject(NSMutableArray(), forKey: favoritesKey)
    sharedDefaults?.synchronize()
  }
  
  public func sync(completion: (results: NSArray) -> Void) {
    
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Favorite", predicate: predicate)
    
    publicDB.performQuery(query, inZoneWithID: nil) {
      results, error in
      
      if error != nil {
        print("There is an error:\(error)")
      } else {
        dispatch_async(dispatch_get_main_queue()) {
          let resultsArray = results! as [CKRecord]
          completion(results: resultsArray)
        }
      }
    }
  }
}


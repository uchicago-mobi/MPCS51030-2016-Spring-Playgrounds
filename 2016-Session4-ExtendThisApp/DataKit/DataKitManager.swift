//
//  DataKitManager.swift
//
//  Created by T. Andrew Binkowski on 4/19/16.
//  Copyright (c) 2015 The University of Chicago. All rights reserved.
//

import Foundation
import CloudKit

/// To enable extension data sharing, we need to use an app group
let sharedAppGroup: String = "group.2016-extend-this-app"

/// The key for our defaults storage
let favoritesKey: String = "Favorites"

// -----------------------------------------------------------------------------
// MARK: - DataKitManagerProtocol
/** 
    DataKitManager

    A protocol that all our data storage methods will conform to so that we can
    use a consistent API when accessing our data
*/
protocol DataKitManager {
    func add(object anObject: NSObject)
    func reset()
    func currentList() -> NSMutableArray
}


//
// MARK: - Local DefaultsManager
//

/// LocalDefaultsManager
/// Store NSUserDefaults in local defaults in app group suite
public class LocalDefaultsManager: DataKitManager {
    public static let sharedInstance = LocalDefaultsManager()
    
    let sharedDefaults: NSUserDefaults?
    var favorites: NSMutableArray?
  
    ///
    init() {
        sharedDefaults = NSUserDefaults(suiteName: sharedAppGroup)
        print(sharedDefaults?.dictionaryRepresentation())
    }
  
    ///
    public func add(object anObject: NSObject) {
        let current: NSMutableArray = currentList()
        current.addObject(anObject)
        sharedDefaults?.setObject(current, forKey: favoritesKey)
        sharedDefaults?.synchronize()
    }
  
    ///
    public func currentList() -> NSMutableArray {
        var current: NSMutableArray = []
        if let tempNames: NSArray = sharedDefaults?.arrayForKey(favoritesKey) {
            current = tempNames.mutableCopy() as! NSMutableArray
        }
        return current
    }

    ///
    public func reset() {
        sharedDefaults?.setObject(NSMutableArray(), forKey: favoritesKey)
        sharedDefaults?.synchronize()
    }
}


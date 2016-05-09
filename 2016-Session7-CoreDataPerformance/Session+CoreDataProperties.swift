//
//  Session+CoreDataProperties.swift
//  2016-CoreDataStack
//
//  Created by T. Andrew Binkowski on 4/11/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Session {

    @NSManaged var timestamp: NSDate?
    @NSManaged var startTime: NSDate?
    @NSManaged var active: NSNumber?
    @NSManaged var uuid: String?
    @NSManaged var user: User?

}

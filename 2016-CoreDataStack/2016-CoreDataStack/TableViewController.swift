//
//  TableViewController.swift
//  2016-CoreDataStack
//
//  Created by T. Andrew Binkowski on 4/11/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  /// For this implementation, the Core Data stack is in the AppDelegate (the
  /// most singlety singleton of them all).  For convienence, let's keep a
  /// refernce to it
  let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
  
  /// Create a fetched results controller lazily with a closure expression.
  /// There are many different variations on how you could do this, but this
  /// is the the most "contained"
  lazy var fetchedResultsController: NSFetchedResultsController = {
    let fetchRequest = NSFetchRequest(entityName: "User")
    let primarySortDescriptor = NSSortDescriptor(key: "gender", ascending: true)
    //let secondarySortDescriptor = NSSortDescriptor(key: "favoriteFood", ascending: true)
    //fetchRequest.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
    fetchRequest.sortDescriptors = [primarySortDescriptor]
    
    let frc = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: self.appDelegate!.managedObjectContext,
      sectionNameKeyPath: "name",
      cacheName: nil)
    
    frc.delegate = self
    
    return frc
  }()
  
  /// Do a fetch when the view appears
  override func viewDidLoad() {
    super.viewDidLoad()
    
    do {
      try fetchedResultsController.performFetch()
    } catch {
      print("An error occurred")
    }
  }
  
  //
  // MARK: - Table view data source
  //
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if let sections = fetchedResultsController.sections {
      return sections.count
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let currentSection = sections[section]
      return currentSection.numberOfObjects
    }
    return 0
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    let user = fetchedResultsController.objectAtIndexPath(indexPath) as! User
    
    cell.textLabel?.text = user.name
    cell.detailTextLabel?.text = "742 Evergreen Terrace"
    
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let sections = fetchedResultsController.sections {
      let currentSection = sections[section]
      return currentSection.name
    }
    
    return nil
  }
  
}
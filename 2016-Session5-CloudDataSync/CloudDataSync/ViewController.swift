//
//  ViewController.swift
//  CloudDataSync
//
//  Created by T. Andrew Binkowski on 4/19/15.
//  Copyright (c) 2015 The University of Chicago. All rights reserved.
//

import UIKit
import CoreData
import DataKit
import CloudKit

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  var favorites = [CKRecord]()

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    //.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
  }
  
  override func viewWillAppear(animated: Bool) {
   refreshTable()
  }
  
  func refreshTable() {
   // Load the fetch
    CloudKitManager.sharedInstance.sync { (results) -> Void in
      // Note: This closure is happening on the main thread
      self.favorites = results as! [CKRecord]
      self.tableView.reloadData()
    }

  }
  
  // MARK: - Table View
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    self.configureCell(cell, atIndexPath: indexPath)
    return cell
  }
  
  func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
    
    let favoriteRecord = favorites[indexPath.row]
    print("configureCell: \(favoriteRecord)")
    
    cell.textLabel!.text = favoriteRecord.creationDate?.description
    cell.backgroundColor = UIColor.randomColor()
    cell.detailTextLabel!.text = favoriteRecord.objectForKey("name") as? String
  }
  
  // MARK: Table Editing
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    /* if editingStyle == .Delete {
     }
     */
  }
  
  
  @IBAction func deleteAllFavorites(sender: UIBarButtonItem) {
    let ids: [CKRecordID] = favorites.map { $0.recordID }
    
    CloudKitManager.sharedInstance.deleteList(ids) { (success) in
      if success == true {
        // Update local data store
        self.favorites.removeAll()
        self.tableView.reloadData()
      }
    }
  }
  
  // MARK: Button
  @IBAction func tapAddItem(sender: AnyObject) {
    print("Adding a item")
    
    CloudKitManager.sharedInstance.add(object: "Tap from App") { (record, success) in
      if success == true {
        print("Success")
        // Update local data store
        if let record = record {
          self.favorites.append(record)
          self.tableView.reloadData()
        }
        
      }
    }
  }
}
//
//  SearchTableViewController.swift
//  2016-CoreDataStack
//
//  Created by T. Andrew Binkowski on 4/11/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  
  
  /// For this implementation, the Core Data stack is in the AppDelegate (the
  /// most singlety singleton of them all).  For convienence, let's keep a
  /// refernce to it
  let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
  
  
  /// Predicate variables
  var currentPredicate: NSPredicate?
  
  /// Create a fetched results controller lazily with a closure expression.
  /// There are many different variations on how you could do this, but this
  /// is the the most "contained"
  lazy var fetchedResultsController: NSFetchedResultsController = { 
    let fetchRequest = NSFetchRequest(entityName: "User")
    let primarySortDescriptor = NSSortDescriptor(key: "gender", ascending: true)
    fetchRequest.sortDescriptors = [primarySortDescriptor]
    fetchRequest.predicate = self.currentPredicate
    //fetchRequest.fetchBatchSize = 20
    //fetchRequest.propertiesToFetch = ["","",""]
    
    let frc = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: self.appDelegate!.managedObjectContext,
      sectionNameKeyPath: "gender",
      cacheName: nil)
    
    frc.delegate = self
    return frc
  }()
  
  /// Search bar
  let searchController = UISearchController(searchResultsController: nil)
  
  /// Do a fetch when the view appears
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Load up the search controller.  There are many options on how it displays
    // that do not effect the behavior.
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.searchBarStyle = .Prominent
    //searchController.hidesNavigationBarDuringPresentation = false
    
    // Show a scope bar for additional filtering parameters
    searchController.searchBar.scopeButtonTitles = ["Like Beer", "Likes Wine"]
    searchController.searchBar.delegate = self
    
    // Place the search bar in the header
    tableView.tableHeaderView = searchController.searchBar
    //navigationItem.titleView = searchController.searchBar
    definesPresentationContext = true
    
    // Offset the table to hide the search bar
    //tableView.contentOffset = CGPoint(x:0, y:44)
    
    
    fetch()
  }
  
  
  
  //
  // MARK: - Data Fetch and Format
  //
  
  /// Perform a fetch against the Core Data store.  This will be called many
  /// different times: initialization, search, cleared search.
  func fetch() {
    do {
      fetchedResultsController.fetchRequest.predicate = currentPredicate
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("An error occurred: \(error.localizedDescription)")
    }
  }
  
  /// Filter the data store by the text query.
  /// - Todo: Search against the text
  ///
  func filterResultsForSearchText(text: String, scope: String = "All") {
    print("SearchBar: \(text) Scopte: \(scope)")
    
    if text.characters.count == 0 {
      // True predicate matches everything
      currentPredicate = NSPredicate(format: "TRUEPREDICATE")
    } else {
      currentPredicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
    }
    fetch()
    tableView.reloadData()
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


///
/// UISearchResultsDelegate
///

extension SearchTableViewController: UISearchResultsUpdating {
  
  /// Update the search results based on the text in the search bar.  We could
  /// also use the scope bar, but we are not in this example
  /// - paremeter searchController: The search controller sending the message
  ///
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    // Use this is you want to use the scope to filter on as well
    //let searchBar = searchController.searchBar
    //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    let scope = "Dummy Text to hide scope for now"
    
    filterResultsForSearchText(searchController.searchBar.text!,scope: scope)
  }
}

///
/// UISearchBarDelegate
///
extension SearchTableViewController: UISearchBarDelegate {
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterResultsForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
  }
}

//
//  SearchUsersViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 4/8/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class SearchUsersViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  let searchController = UISearchController(searchResultsController: nil)

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: kCellIdAddFriend, bundle: nil), forCellReuseIdentifier: kCellIdAddFriend)
    navigationItem.hidesBackButton = true
    searchSetup()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    performSelector(#selector(initiateSearchBarResponder), withObject: nil, afterDelay: 0.01)
  }

  func searchSetup() {
    searchController.searchResultsUpdater = self
    searchController.delegate = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    tableView.tableHeaderView = searchController.searchBar
    definesPresentationContext = true
    searchController.searchBar.barTintColor = .groupTableViewBackgroundColor()
  }

  func initiateSearchBarResponder() {
    searchController.searchBar.becomeFirstResponder()
  }

  func filterContentForSearchText(searchText: String, scope: String = "All") {
//    filteredUsers = users.filter { user in
//      return user.name.lowercaseString.containsString(searchText.lowercaseString)
//    }
//    tableView.reloadData()
  }
}

extension SearchUsersViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdAddFriend)! as! AddFriendCell

    return cell
  }
}

extension SearchUsersViewController: UISearchResultsUpdating, UISearchControllerDelegate {

  //MARK -UISearchResultsUpdating
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    if searchController.searchBar.text!.isEmpty {
//      filteredUsers = users
      return
    }
    filterContentForSearchText(searchController.searchBar.text!)
  }

  //MARK - UISearchControllerDelegate
  func willPresentSearchController(searchController: UISearchController) {
//    filteredUsers = users
    UIApplication.sharedApplication().statusBarStyle = .Default
  }

  func willDismissSearchController(searchController: UISearchController) {
//    filteredUsers = users
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    navigationController?.popViewControllerAnimated(true)
  }
}


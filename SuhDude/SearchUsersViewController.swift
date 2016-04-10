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

  var users = [BackendlessUser]()

  var filteredUsers = [BackendlessUser]() {
    didSet {
      self.tableView.reloadData()
    }
  }

  var selectedIndexPaths = NSMutableSet()
  var loadingIndexPaths = NSMutableSet()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: kCellIdAddFriend, bundle: nil), forCellReuseIdentifier: kCellIdAddFriend)
    navigationItem.hidesBackButton = true
    searchSetup()

    retrieveUsersAndSetData()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    performSelector(#selector(initiateSearchBarResponder), withObject: nil, afterDelay: 0.01)
  }

  func retrieveUsersAndSetData() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)

    UserManager.retrieveNonFriends { (users, fault) -> Void in
      guard let nonFriends = users else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        return
      }
      self.users = nonFriends
      self.filteredUsers = self.users
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      self.tableView.reloadData()
    }
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

extension SearchUsersViewController: UITableViewDataSource, UITableViewDelegate, AddFriendCellDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredUsers.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdAddFriend)! as! AddFriendCell

    cell.user = filteredUsers[indexPath.row]
    cell.isLoading = loadingIndexPaths.containsObject(indexPath)
    cell.selected = selectedIndexPaths.containsObject(indexPath)
    cell.setUpCell()
    cell.delegate = self

    return cell
  }

  func didTapAddButton(button: UIButton) {
    //
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


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
  @IBOutlet var tvYconstraint: NSLayoutConstraint!

  let searchController = UISearchController(searchResultsController: nil)

  var users = [BackendlessUser]()

  var searching = false {
    didSet {
      self.tableView.reloadData()
    }
  }

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
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterUserViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    navigationItem.hidesBackButton = true
    searchSetup()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    performSelector(#selector(initiateSearchBarResponder), withObject: nil, afterDelay: 0.01)
  }

  func retrieveUsersFromSearch() {
//    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    UserManager.retrieveAllUsers(withNameLike: searchController.searchBar.text!) { (users, fault) in
      guard let users = users else {
        MBProgressHUD.hideOnMain(forView: self.view)
        return
      }
      self.users = users
      self.filteredUsers = self.users
      MBProgressHUD.hideOnMain(forView: self.view)
      self.tableView.reloadData()
    }
  }

  func retrieveSuggestedFriends() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    UserManager.retrieveNonFriendsOfFriends { (users, fault) in
      guard let nonFriends = users else {
        MBProgressHUD.hideOnMain(forView: self.view)
        return
      }
      self.users = nonFriends
      self.filteredUsers = self.users
      MBProgressHUD.hideOnMain(forView: self.view)
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

    searchController.searchBar.placeholder = "Search users"
    searchController.searchBar.barTintColor = .groupTableViewBackgroundColor()
  }

  func initiateSearchBarResponder() {
    searchController.searchBar.becomeFirstResponder()
  }

  func keyboardWillShow(notification: NSNotification) {
    guard let kbHeight = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height else { return }
    tvYconstraint.constant = kbHeight
  }
}

extension SearchUsersViewController: UITableViewDataSource, UITableViewDelegate, AddFriendCellDelegate {
  //MARK - UITableViewDataSource
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

  //MARK - UITableViewDelegate
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return searching ? "Results" : "Suggested"
  }

  //MARK - AddFriendCellDelegate
  func didTapAddButton(button: UIButton) {
    //
  }
}

extension SearchUsersViewController: UISearchResultsUpdating, UISearchControllerDelegate {

  //MARK -UISearchResultsUpdating
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    if searchController.searchBar.text!.isEmpty {
      searching = false
      retrieveSuggestedFriends()
      return
    }
    searching = true
    retrieveUsersFromSearch()
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
//
//  ViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/3/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var noFriendsLabel: UILabel!

  var refreshControl = UIRefreshControl()
  let searchController = UISearchController(searchResultsController: nil)

  var isInitialLoad = true

  var backendless = Backendless.sharedInstance()
  let kSegueMainToSignUp = "mainToSignUp"
  let kSegueMainToAddFriends = "mainToAddFriends"
  let kCellIDMain = "mainCell"

  var loadingIndexPaths = NSMutableSet()

  var friendships = [Friendship]() {
    didSet {
      self.tableView.reloadData()
    }
  }

  var filteredFriendships = [Friendship]() {
    didSet {
      self.tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    pullToRefresh()
    self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    searchSetup()

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(retrieveUsersAndSetData), name: kNotifPushReceived, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(retrieveUsersAndSetData), name: UIApplicationWillEnterForegroundNotification, object: nil)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
    navBarStyling()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkForCurrentUser()

    if isInitialLoad {
      tableView.setContentOffset(CGPointMake(0, -20), animated: false)

      isInitialLoad = false
    }
  }

  func pullToRefresh() {
//    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//    refreshControl.tintColor = UIColor.whiteColor()
    refreshControl.backgroundColor = UIColor.groupTableViewBackgroundColor()
    refreshControl.addTarget(self, action: #selector(retrieveUsersAndSetData), forControlEvents: UIControlEvents.ValueChanged)
    tableView.addSubview(refreshControl)
    refreshControl.superview?.sendSubviewToBack(refreshControl)
  }

  func navBarStyling() {
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    navigationController?.navigationBar.tintColor = .whiteColor()
    navigationController?.navigationBar.barTintColor = UIColor.customDarkBlueGreen()
    title = "Suh Dude"
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.whiteColor(),
       NSFontAttributeName: UIFont(name: "Knewave", size: 24)!]
  }

  func retrieveUsersAndSetData() {
    if let currentUser = backendless.userService.currentUser {
      Friendship.retrieveFriendshipsForUser(currentUser, approved: true) { (friendships, fault) -> Void in
        dispatch_async(dispatch_get_main_queue(),{
          self.refreshControl.endRefreshing()
          guard let friendships = friendships else {
            return
          }
          self.friendships = friendships
          self.filteredFriendships = self.friendships

          self.noFriendsLabel.hidden = true
          if friendships.count == 0 {
            self.noFriendsLabel.hidden = false
          }
        })
      }
    }
  }

  func checkForCurrentUser() {
    if backendless.userService.currentUser == nil {
      print("No current user")
      self.filteredFriendships.removeAll()
      self.tableView.reloadData()
      performSegueWithIdentifier(kSegueMainToSignUp, sender: self)
    } else {
      print("Current user is: \(Backendless().userService.currentUser.name)")
      retrieveUsersAndSetData()
    }
  }

  func searchSetup() {
    searchController.searchResultsUpdater = self
    searchController.delegate = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    tableView.tableHeaderView = searchController.searchBar
    definesPresentationContext = true
    searchController.searchBar.barTintColor = .whiteColor()

    if #available(iOS 9.0, *) {
      (UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self])).tintColor = .customDarkerBlueGreen()
    } else {
      // Fallback on earlier versions
    }
  }

  func filterContentForSearchText(searchText: String, scope: String = "All") {
    filteredFriendships = friendships.filter { friendship in
      return friendship.friend().name.lowercaseString.containsString(searchText.lowercaseString)
    }
    tableView.reloadData()
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredFriendships.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIDMain) as! MainTableViewCell
    cell.isLoading = loadingIndexPaths.containsObject(indexPath)
    cell.friendship = filteredFriendships[indexPath.row]
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    if !loadingIndexPaths.containsObject(indexPath) {
      self.loadingIndexPaths.addObject(indexPath)
      self.tableView.reloadData()

      let friendship = filteredFriendships[indexPath.row]
      friendship.update(backendless.userService.currentUser) { (fault) -> Void in
        if fault != nil {
          self.loadingIndexPaths.removeObject(indexPath)
          self.tableView.reloadData()
        } else {
          let selectedUser = self.friendships[indexPath.row].friend()
          PushManager.publishMessageAsPushNotificationAsync("from \(self.backendless.userService.currentUser.name)", channel: selectedUser.objectId, completed: { (fault) -> Void in
            if fault != nil {

            } else {
              self.filteredFriendships.moveItem(fromIndex: indexPath.row, toIndex: 0)
            }
            self.loadingIndexPaths.removeObject(indexPath)
            self.tableView.reloadData()
          })
        }
      }
    }
  }
}

extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate {

  //MARK -UISearchResultsUpdating
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    if searchController.searchBar.text!.isEmpty {
      filteredFriendships = friendships
      return
    }

    filterContentForSearchText(searchController.searchBar.text!)
  }

  //MARK - UISearchControllerDelegate
  func willPresentSearchController(searchController: UISearchController) {
    filteredFriendships = friendships
    UIApplication.sharedApplication().statusBarStyle = .Default
  }

  func willDismissSearchController(searchController: UISearchController) {
    filteredFriendships = friendships
    UIApplication.sharedApplication().statusBarStyle = .LightContent
  }
}
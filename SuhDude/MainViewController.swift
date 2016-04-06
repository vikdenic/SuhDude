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

  override func viewDidLoad() {
    super.viewDidLoad()
    pullToRefresh()
    self.tableView.tableFooterView = UIView(frame: CGRect.zero)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(checkForCurrentUser), name: kNotifPushReceived, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(checkForCurrentUser), name: UIApplicationWillEnterForegroundNotification, object: nil)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
    navBarStyling()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkForCurrentUser()
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
    title = "Suh Dude"
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.whiteColor(),
       NSFontAttributeName: UIFont(name: "Knewave", size: 24)!]
  }

  func retrieveUsersAndSetData() {
    Friendship.retrieveFriendshipsForUser(backendless.userService.currentUser, includeGroups: false) { (friendships, fault) -> Void in
      dispatch_async(dispatch_get_main_queue(),{
        self.refreshControl.endRefreshing()
        guard let friendships = friendships else {
          return
        }
        self.friendships = friendships

        self.noFriendsLabel.hidden = true
        if friendships.count == 0 {
          self.noFriendsLabel.hidden = false
        }
      })
    }
  }

  func checkForCurrentUser() {
    if backendless.userService.currentUser == nil {
      print("No current user")
      self.friendships.removeAll()
      self.tableView.reloadData()
      performSegueWithIdentifier(kSegueMainToSignUp, sender: self)
    } else {
      print("Current user is: \(Backendless().userService.currentUser.name)")
      retrieveUsersAndSetData()
    }
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friendships.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIDMain) as! MainTableViewCell
    cell.isLoading = loadingIndexPaths.containsObject(indexPath)
    cell.friendship = friendships[indexPath.row]
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    if !loadingIndexPaths.containsObject(indexPath) {
      self.loadingIndexPaths.addObject(indexPath)
      self.tableView.reloadData()

      let friendship = friendships[indexPath.row]
      friendship.update(backendless.userService.currentUser) { (fault) -> Void in
        if fault != nil {
          self.loadingIndexPaths.removeObject(indexPath)
          self.tableView.reloadData()
        } else {
          let selectedUser = self.friendships[indexPath.row].friend()
          PushManager.publishMessageAsPushNotificationAsync("from \(self.backendless.userService.currentUser.name)", channel: selectedUser.objectId, completed: { (fault) -> Void in
            if fault != nil {

            } else {
              self.friendships.moveItem(fromIndex: indexPath.row, toIndex: 0)
            }
            self.loadingIndexPaths.removeObject(indexPath)
            self.tableView.reloadData()
          })
        }
      }
    }
  }
}
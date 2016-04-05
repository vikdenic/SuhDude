//
//  AddFriendsViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/8/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController {

  @IBOutlet var tableView: UITableView!

  var backendless = Backendless.sharedInstance()
  var users = [BackendlessUser]() {
    didSet {
      self.tableView.reloadData()
    }
  }

  var selectedIndexPaths = NSMutableSet()
  var loadingIndexPaths = NSMutableSet()

  let kCellIdAddFriend = "addFriendCell"

  override func viewDidLoad() {
    super.viewDidLoad()
    retrieveUsersAndSetData()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navBarStyling()
  }
  
  func retrieveUsersAndSetData() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)

    UserManager.retrieveNonFriends { (users, fault) -> Void in
      guard let nonFriends = users else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        return
      }
      self.users = nonFriends
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      self.tableView.reloadData()
    }
  }

  func navBarStyling() {
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.whiteColor(),
       NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 20)!]
//    navigationController?.navigationBar.topItem?.title = ""
    navigationController?.viewControllers[0].title = "" //removes back button text
    title = "Add Friends"

  }
}

extension AddFriendsViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdAddFriend)! as! AddFriendTableViewCell
    cell.user = users[indexPath.row]
    cell.isLoading = loadingIndexPaths.containsObject(indexPath)
    cell.selected = selectedIndexPaths.containsObject(indexPath)
    cell.setUpCell()
    
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    if !loadingIndexPaths.containsObject(indexPath) && !selectedIndexPaths.containsObject(indexPath) {

      let selectedUser = users[indexPath.row]

      self.loadingIndexPaths.addObject(indexPath)
      self.tableView.reloadData()

      let friendship = Friendship(members: [backendless.userService.currentUser, selectedUser])
      friendship.save { (fault) -> Void in
        if fault != nil {
          //TODO: Handle friendship creation error
        } else {
          self.selectedIndexPaths.addObject(indexPath)
        }
        self.loadingIndexPaths.removeObject(indexPath)
        self.tableView.reloadData()
      }

    }

  }
}
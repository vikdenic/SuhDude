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
  var users = [BackendlessUser]()

  let kCellIdAddFriend = "addFriendCell"

  override func viewDidLoad() {
    super.viewDidLoad()
    retrieveUsersAndSetData()
//    Friendship.retrieveAllFriendships { (friendships, fault) -> Void in
//      guard let friendships = friendships else { return }
//
//      for friendship in friendships {
//        for member in friendship.members! {
//          print(member.name)
//        }
//      }
//    }
  }

  func retrieveUsersAndSetData() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)

    UserManager.retrieveAllUsers { (users, fault) -> Void in
      guard let friends = users else {
        print("Server reported an error: \(fault)")
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        return
      }
      self.users = friends
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      self.tableView.reloadData()
    }
  }
}

extension AddFriendsViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdAddFriend)! as! AddFriendTableViewCell
    cell.user = users[indexPath.row]
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    let selectedUser = users[indexPath.row]
//    selectedUser.setProperty("selected", object: true)
    tableView.reloadData()

    let friendship = Friendship(members: [backendless.userService.currentUser, selectedUser])
    friendship.save { (fault) -> Void in
      //
    }
  }
}
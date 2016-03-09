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

  var users = [BackendlessUser]()

  let kCellIdAddFriend = "addFriendCell"

  override func viewDidLoad() {
    super.viewDidLoad()
    retrieveUsersAndSetData()
  }

  func retrieveUsersAndSetData() {
    UserManager.retrieveAllUsers { (users, fault) -> Void in
      guard let friends = users else {
        print("Server reported an error: \(fault)")
        return
      }
      self.users = friends
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
    print("was \(selectedUser.getProperty("selected").boolValue)")
    selectedUser.setProperty("selected", object: !selectedUser.getProperty("selected").boolValue)
    print("is \(selectedUser.getProperty("selected").boolValue)")
    tableView.reloadData()
  }
}
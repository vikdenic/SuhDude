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

  var backendless = Backendless.sharedInstance()
  let kSegueMainToSignUp = "mainToSignUp"
  let kCellIDMain = "mainCell"

  var friends = [BackendlessUser]()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.tableFooterView = UIView(frame: CGRect.zero)

    Friendship.retrieveAllFriendships()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkForCurrentUser()
    retrieveUsersAndSetData { () -> Void in
      //
    }

//    Friendship.retrieveAllFriendships()
  }

  func retrieveUsersAndSetData(completed : () -> Void) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    UserManager.retrieveAllUsers { (users, fault) -> Void in
      guard let friends = users else {
        print("Server reported an error: \(fault)")
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        return
      }
      self.friends = friends
      self.tableView.reloadData()
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      completed()
    }
  }

  func checkForCurrentUser() {
    if backendless.userService.currentUser == nil {
      print("No current user")
      performSegueWithIdentifier(kSegueMainToSignUp, sender: self)
    } else {
      print("Current user is: \(Backendless().userService.currentUser.name)")
    }
  }

  @IBAction func onAddButtonTapped(sender: AnyObject) {
    
  }

  @IBAction func onLogoutButtonTapped(sender: AnyObject) {

    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    backendless.userService.logout({ (object) -> Void in
      print("Successfully logged out user")
      self.performSegueWithIdentifier(self.kSegueMainToSignUp, sender: self)
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      PushManager.cancelDeviceRegistrationAsync()

      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
        if self.backendless.userService.currentUser == nil { //current workaround for bug
          self.performSegueWithIdentifier(self.kSegueMainToSignUp, sender: self)
        }
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIDMain)!
    let friend = friends[indexPath.row]
    cell.textLabel?.text = friend.name
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    let selectedUser = friends[indexPath.row]
    selectedUser.setProperty("selected", object: false)
    self.backendless.userService.update(selectedUser)

//    PushManager.publishMessageAsPushNotificationAsync("from \(backendless.userService.currentUser.name)", channel: selectedUser.objectId)
  }
}
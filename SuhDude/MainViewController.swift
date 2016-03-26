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

  var friendships = [Friendship]() {
    didSet {
      self.tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.tableFooterView = UIView(frame: CGRect.zero)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.retrieveUsersAndSetData(_:)), name: kNotifPushReceived, object: nil)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkForCurrentUser()
  }

  func retrieveUsersAndSetData(completed : (() -> Void)?) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)

    Friendship.retrieveFriendshipsForUser(backendless.userService.currentUser, includeGroups: false) { (friendships, fault) -> Void in

      guard let friendships = friendships else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        return
      }
      self.friendships = friendships
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  }

  func checkForCurrentUser() {
    if backendless.userService.currentUser == nil {
      print("No current user")
      performSegueWithIdentifier(kSegueMainToSignUp, sender: self)
    } else {
      print("Current user is: \(Backendless().userService.currentUser.name)")
      retrieveUsersAndSetData(nil)
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
          MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friendships.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIDMain) as! MainTableViewCell
    cell.friendship = friendships[indexPath.row]
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    let friendship = friendships[indexPath.row]
    friendship.update(backendless.userService.currentUser) { (fault) -> Void in
      if fault != nil {

      } else {
        let selectedUser = self.friendships[indexPath.row].friend()
        PushManager.publishMessageAsPushNotificationAsync("from \(self.backendless.userService.currentUser.name)", channel: selectedUser.objectId, completed: { (fault) -> Void in
          if fault != nil {

          } else {
            self.friendships.moveItem(fromIndex: indexPath.row, toIndex: 0)
            self.tableView.reloadData()
          }
        })
      }
    }
  }
}
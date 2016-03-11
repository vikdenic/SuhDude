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
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkForCurrentUser()
    retrieveUsersAndSetData { () -> Void in
      //
    }
  }

  func retrieveUsersAndSetData(completed : () -> Void) {
    UserManager.retrieveAllUsers { (users, fault) -> Void in
      guard let friends = users else {
        print("Server reported an error: \(fault)")
        return
      }
      self.friends = friends
      self.tableView.reloadData()
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

    backendless.userService.logout({ (object) -> Void in
      self.performSegueWithIdentifier(self.kSegueMainToSignUp, sender: self)
      self.navigationController?.popToRootViewControllerAnimated(true)
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
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
    guard let someDeviceId = selectedUser.getProperty("deviceId") as? String else {
      retrieveUsersAndSetData({ () -> Void in
        guard let _ = selectedUser.getProperty("deviceId") as? String else {
          UIAlertController.showAlert("\(selectedUser.name) is not currently logged in", message: "tell them to log back in dude", viewController: self)
          return
        }
      })
      return
    }

    PushManager.publishMessageAsPushNotificationAsync("from \(backendless.userService.currentUser.name)", deviceId: someDeviceId)
  }
}
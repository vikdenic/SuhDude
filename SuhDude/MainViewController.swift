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

  var friends = [BackendlessUser]()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.tableFooterView = UIView(frame: CGRect.zero)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkForCurrentUser()

    UserManager.retrieveAllUsers { (users, fault) -> Void in
      guard let friends = users else {
        print("Server reported an error: \(fault)")
        return
      }
      self.friends = friends
      self.tableView.reloadData()
    }
  }

  func checkForCurrentUser() {
    if backendless.userService.currentUser == nil {
      print("No current user")
      performSegueWithIdentifier(kSegueMainToSignUp, sender: self)
    } else {
      print("Current user is: \(Backendless().userService.currentUser)")
    }
  }

  @IBAction func onLogoutButtonTapped(sender: AnyObject) {
    backendless.userService.logout({ (object) -> Void in
      self.performSegueWithIdentifier(self.kSegueMainToSignUp, sender: self)
      self.navigationController?.popToRootViewControllerAnimated(true)
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
    }
  }

  func publishMessageAsPushNotificationAsync(message: String, deviceId: String) {

    let deliveryOptions = DeliveryOptions()
    deliveryOptions.pushSinglecast = [deviceId]
    deliveryOptions.pushPolicy(PUSH_ONLY)

    let publishOptions = PublishOptions()
    publishOptions.headers = ["ios-sound":"suhDude2NL.aif"]

    backendless.messaging.publish("default", message: message, publishOptions:publishOptions, deliveryOptions:deliveryOptions,
      response:{ ( messageStatus : MessageStatus!) -> () in
        print("MessageStatus = \(messageStatus.status) ['\(messageStatus.messageId)']")
      },
      error: { ( fault : Fault!) -> () in
        print("Server reported an error: \(fault)")
      }
    )
  }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friends.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("mainCell")!
    let friend = friends[indexPath.row]
    cell.textLabel?.text = friend.name
    return cell
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    let selectedUser = friends[indexPath.row]
    guard let someDeviceId = selectedUser.getProperty("deviceId") as? String else {
      return
    }

    publishMessageAsPushNotificationAsync("Suh dood.", deviceId: someDeviceId)
  }
}
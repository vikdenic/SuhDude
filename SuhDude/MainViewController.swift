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

    User.retrieveAllUsers { (users, fault) -> Void in
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
}
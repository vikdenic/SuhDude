//
//  AddFriendsViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/8/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit
import MessageUI

class AddFriendsViewController: UIViewController, MFMessageComposeViewControllerDelegate, UIToolbarDelegate {

  @IBOutlet var segmentedControl: UISegmentedControl!
  @IBOutlet var inviteBarButton: UIBarButtonItem!
  @IBOutlet var tableView: UITableView!

  var backendless = Backendless.sharedInstance()
  var users = [BackendlessUser]()

  var friendships = [Friendship]() {
    didSet {
      self.tableView.reloadData()
    }
  }

  var selectedIndexPaths = NSMutableSet()
  var loadingIndexPaths = NSMutableSet()

  override func viewDidLoad() {
    super.viewDidLoad()
    unapprovedFriendshipsRetrieval()

    tableView.registerNib(UINib(nibName: kCellIdFriendRequest, bundle: nil), forCellReuseIdentifier: kCellIdFriendRequest)
    tableView.registerNib(UINib(nibName: kCellIdAddFriend, bundle: nil), forCellReuseIdentifier: kCellIdAddFriend)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navBarStyling()
  }

  func unapprovedFriendshipsRetrieval() {

    Friendship.retrieveFriendshipsForUser(backendless.userService.currentUser, approved: false) { (unapprovedFriendships, fault) in
      guard let unapprovedFriendships = unapprovedFriendships else {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        return
      }
      self.friendships = unapprovedFriendships
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  }

  @IBAction func onSegmentSelected(sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {

    } else {

    }
  }

  @IBAction func onInviteButtonTapped(sender: AnyObject) {

    guard MFMessageComposeViewController.canSendText() else {
      print("SMS services are not available")
      return
    }

    let composeVC = MFMessageComposeViewController()
    composeVC.messageComposeDelegate = self

    // Configure the fields of the interface.
//    composeVC.recipients = ["4085551212"]
    composeVC.body = "dude, download the Suh Dude app: http://onelink.to/suhdude"

    // Present the view controller modally.
    self.presentViewController(composeVC, animated: true, completion: nil)
  }

  func navBarStyling() {
    UIApplication.sharedApplication().statusBarStyle = .Default
    navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
    navigationController?.navigationBar.tintColor = .customDarkBlueGreen()
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.darkTextColor(),
       NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 20)!]
//    navigationController?.navigationBar.topItem?.title = ""
    navigationController?.viewControllers[0].title = "" //removes back button text
    title = "Add Friends"

    inviteBarButton.setTitleTextAttributes([
      NSFontAttributeName : UIFont(name: "AvenirNext-Medium", size: 18)!],
                                         forState: UIControlState.Normal)
  }

  func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }

  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .TopAttached
  }
}


extension AddFriendsViewController: UITableViewDataSource, UITableViewDelegate, FriendRequestCellDelegate, AddFriendCellDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friendships.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdFriendRequest)! as! FriendRequestCell

    cell.friendship = friendships[indexPath.row]
//    cell.isLoading = loadingIndexPaths.containsObject(indexPath)
//    cell.selected = selectedIndexPaths.containsObject(indexPath)
//    cell.setUpCell()
    cell.delegate = self

    return cell
  }

  //MARK - FriendRequestCellDelegate
  func didTapApproveButton(button: UIButton) {
    print("approve")
  }

  func didTapDeclineButton(button: UIButton) {
    print("decline")
  }

  //MARK - AddFriendCellDelegate
  func didTapAddButton(button: UIButton) {
    print("add")
  }

//  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    tableView.deselectRowAtIndexPath(indexPath, animated: true)
//
//    if !loadingIndexPaths.containsObject(indexPath) && !selectedIndexPaths.containsObject(indexPath) {
//
//      let selectedUser = users[indexPath.row]
//
//      self.loadingIndexPaths.addObject(indexPath)
//      self.tableView.reloadData()
//
//      let friendship = Friendship(members: [backendless.userService.currentUser, selectedUser])
//      friendship.save { (fault) -> Void in
//        if fault != nil {
//          //TODO: Handle friendship creation error
//        } else {
//          self.selectedIndexPaths.addObject(indexPath)
//        }
//        self.loadingIndexPaths.removeObject(indexPath)
//        self.tableView.reloadData()
//      }
//
//    }
//
//  }
}
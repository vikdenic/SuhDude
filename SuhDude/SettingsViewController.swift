//
//  SettingsViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/26/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

  var backendless = Backendless.sharedInstance()
  var muteApp = false

  let kSegueToEdit = "settingsToEdit"

  @IBOutlet var dismissBarButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpForm()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setupTitle()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    UIApplication.sharedApplication().statusBarStyle = .Default
  }

  //MARK: Eureka Form
  func setUpForm() {

    form = Section("My Account")

    <<< ButtonRow("Edit Profile") {
      $0.title = $0.tag
      $0.presentationMode = .SegueName(segueName: kSegueToEdit, completionCallback: nil)
      }
      .onCellSelection { cell, row in
        print("Edit profile row tapped")
      }.cellUpdate {
        $0.cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16.5)
      }

    +++ Section("Account Actions")

    <<< SwitchRow() {
      $0.title = "Mute App"
      $0.value = NSUserDefaults.standardUserDefaults().boolForKey(kDefaultsMuted)
      }.cellUpdate {
        $0.cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16.5)
      }.onChange {
        if $0.value == true {
          self.muteApp = true
          PushManager.cancelDeviceRegistrationAsync()
          print(self.muteApp)
        }
        else {
          self.muteApp = false
          PushManager.registerForPush()
          print(self.muteApp)
        }
    }

    +++ Section("")

    <<< ButtonRow ("Log Out") {
      $0.title = $0.tag
//      $0.presentationMode = .SegueName(segueName: kSegueToEdit, completionCallback: nil)

      }
      .onCellSelection { cell, row in
        self.initiateLogout()
        print("Logout row tapped")
      }.cellUpdate {
        $0.cell.textLabel?.textColor = .customRed()
        $0.cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16.5)
    }

  }

  func setupTitle() {
    title = "Settings"
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.customBlueGreen(),
       NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 20)!]
  }

  @IBAction func onDismissTapped(sender: AnyObject) {
    UIApplication.sharedApplication().statusBarStyle = .LightContent
    dismissViewControllerAnimated(true, completion: nil)
  }

  func initiateLogout(){

    let alert = UIAlertController(title: "Log Out?", message: nil, preferredStyle: .ActionSheet)

    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

    let okayAction = UIAlertAction(title: "Log Out", style: .Default) { (action) -> Void in
      self.logoutUser()
    }

    alert.addAction(okayAction)
    alert.addAction(cancelAction)

    presentViewController(alert, animated: true, completion: nil)
  }

  func logoutUser() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    backendless.userService.logout({ (object) -> Void in
      print("Successfully logged out user")
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      PushManager.cancelDeviceRegistrationAsync()
      self.dismissViewControllerAnimated(true, completion: nil)
      UIApplication.sharedApplication().statusBarStyle = .LightContent
    }) { (fault) -> Void in
      print("Server reported an error: \(fault)")
      if self.backendless.userService.currentUser == nil { //current workaround for bug
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
      }
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  }

}

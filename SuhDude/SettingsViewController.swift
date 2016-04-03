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

  @IBOutlet var dismissBarButton: UIBarButtonItem!

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpForm()
    setupTitle()
  }

  //MARK: Eureka Form
  func setUpForm() {

    form = Section()

    <<< SwitchRow() {
      $0.title = "Mute App"
      $0.value = false
      }.onChange {
        if $0.value == true {
          self.muteApp = true
          print(self.muteApp)
        }
        else {
          self.muteApp = false
          print(self.muteApp)
        }
    }

    <<< LabelRow () {
      $0.title = "Mute Specific Friends"
      $0.value = ">"
      }
      .onCellSelection { cell, row in
        print("Mute specific row tapped")
    }

    +++ Section("")

      <<< LabelRow () {
        $0.title = "Edit Profile"
        $0.value = ">"
        }
        .onCellSelection { cell, row in
          print("Edit profile row tapped")
    }

      +++ Section("")

      <<< LabelRow () {
        $0.title = "Logout"
        $0.value = ""
        }
        .onCellSelection { cell, row in
          self.logoutUser()
          print("Logout row tapped")
    }

  }

  func setupTitle() {
    title = backendless.userService.currentUser.name
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.whiteColor(),
       NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 20)!]

    dismissBarButton.setTitleTextAttributes([
      NSFontAttributeName : UIFont(name: "AvenirNext-DemiBold", size: 18)!],
                                            forState: UIControlState.Normal)
  }

  @IBAction func onDismissTapped(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func logoutUser() {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    backendless.userService.logout({ (object) -> Void in
      print("Successfully logged out user")
//      self.performSegueWithIdentifier(self.kSegueMainToSignUp, sender: self)
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      PushManager.cancelDeviceRegistrationAsync()
      self.dismissViewControllerAnimated(true, completion: nil)

    }) { (fault) -> Void in
      print("Server reported an error: \(fault)")
      if self.backendless.userService.currentUser == nil { //current workaround for bug
//        self.performSegueWithIdentifier(self.kSegueMainToSignUp, sender: self)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
      }
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  }

}

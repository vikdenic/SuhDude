//
//  SettingsViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/26/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  var backendless = Backendless.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = backendless.userService.currentUser.name
      self.navigationController?.navigationBar.titleTextAttributes =
        [NSForegroundColorAttributeName: UIColor.whiteColor(),
         NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 20)!]
    }

  @IBAction func onLogoutTapped(sender: AnyObject) {
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

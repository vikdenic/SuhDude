//
//  ViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/3/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  var backendless = Backendless.sharedInstance()
  let kSegueMainToSignUp = "mainToSignUp"

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkForCurrentUser()
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


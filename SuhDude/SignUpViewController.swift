//
//  SignUpViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/5/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

  @IBOutlet var loginBarButton: UIBarButtonItem!

  var loggingIn = false
  let kSegueSignUpToRegister = "signUpToRegister"

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavBarToClear()

    loginBarButton.setTitleTextAttributes([
      NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 18)!],
      forState: UIControlState.Normal)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loggingIn = false
  }

  @IBAction func onLoginBarButtonTapped(sender: UIBarButtonItem) {
    loggingIn = true
    performSegueWithIdentifier(kSegueSignUpToRegister, sender: self)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let registerVC = segue.destinationViewController as! RegisterUserViewController
    registerVC.loggingIn = loggingIn
  }

}

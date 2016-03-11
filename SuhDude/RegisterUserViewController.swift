//
//  RegisterUserViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/5/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {

  @IBOutlet var usernameTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var continueButton: UIButton!
  @IBOutlet var continueButtonYconstraint: NSLayoutConstraint!

  var backendless = Backendless.sharedInstance()
  var loggingIn = false

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavBarToClear()
    navigationController?.navigationBar.topItem?.title = ""
    usernameTextField.becomeFirstResponder()

    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)

    if loggingIn {
      continueButton.setTitle("log in", forState: .Normal)
    }
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  func keyboardWillShow(notification: NSNotification) {
    guard let kbHeight = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height else { return }

    continueButtonYconstraint.constant = kbHeight
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  @IBAction func onContinueButtonTapped(sender: UIButton) {
    if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
      UIAlertController.showAlert("Please enter a username and password", message: nil, viewController: self)
      return
    } else if !usernameTextField.text!.containsValidCharacters() {
      UIAlertController.showAlert("Username must only contain letters, numbers, and underscores", message: nil, viewController: self)
      return
    }

    if loggingIn {
      loginUser()
    } else {
      registerUser()
    }
  }

  func registerUser() {
    let user = BackendlessUser()
    user.name = usernameTextField.text
    user.password = passwordTextField.text

    backendless.userService.registering(user,
      response: { (registeredUser) -> Void in
        print("User has been registered: \(registeredUser)")

        //Still need to log the user in
        self.loginUser()
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
        UIAlertController.showAlertWithFault(fault, forVC: self)
    }
  }

  func loginUser() {
    backendless.userService.login(usernameTextField.text, password: passwordTextField.text, response: { (loggedInUser) -> Void in
      print("User has been logged in: \(loggedInUser)")
      PushManager.registerForPush()
      self.dismissViewControllerAnimated(true, completion: nil)
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
        UIAlertController.showAlertWithFault(fault, forVC: self)
    }
  }

}

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

  var loggingIn = false

  override func viewDidLoad() {
    super.viewDidLoad()
    usernameTextField.becomeFirstResponder()

    if loggingIn {
      continueButton.setTitle("log in", forState: .Normal)
    }
  }

  @IBAction func onContinueButtonTapped(sender: UIButton) {

  }

}

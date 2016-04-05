//
//  EditProfileViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 4/4/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit
import Eureka

class EditProfileViewController: FormViewController {

  @IBOutlet var saveBarButton: UIBarButtonItem!

  var backendless = Backendless.sharedInstance()

  var username : String!
  var emojiString = "" as String!

  override func viewDidLoad() {
    super.viewDidLoad()

    username = backendless.userService.currentUser.name
    if String(backendless.userService.currentUser.getProperty("spiritEmoji")).fromUnicode().emoIsPureEmoji() {
      emojiString = String(backendless.userService.currentUser.getProperty("spiritEmoji")).fromUnicode()
    }
    setUpForm()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navBarStyling()
  }

  //MARK: Eureka Form
  func setUpForm() {
    form +++ Section(footer:"Your spirit emoji appears next to your username")

      <<< TextRow() {
        $0.title = "Username"
        $0.value = username
        }.cellUpdate {
          $0.cell.textField.autocorrectionType = .No
          $0.cell.textField.autocapitalizationType = .None
        }.onChange { [weak self] row in
          self?.username = row.value
      }

      <<< TextRow() {
        $0.title = "Spirit emoji"

        if emojiString != "" {
          $0.value = emojiString
        } else {
          $0.value = nil
          $0.placeholder = "enter an emoji"
        }

        }.cellUpdate {
          $0.cell.textField.autocorrectionType = .No
          $0.cell.textField.autocapitalizationType = .None
          $0.cell.textField.delegate = self
        }.onChange { [weak self] row in
          self?.emojiString = row.value
      }
  }

  @IBAction func onSaveButtonTapped(sender: AnyObject) {
    if username == "" {
      UIAlertController.showAlert("Please enter a username", message: nil, viewController: self)
      return
    } else if !username.containsValidCharacters() {
      UIAlertController.showAlert("Username must only contain letters, numbers, and underscores", message: nil, viewController: self)
      return
    } else if emojiString == nil {
      UIAlertController.showAlert("Your spirit emoji must be an emoji character", message: nil, viewController: self)
      return
    } else if !emojiString.emoIsPureEmoji() {
      UIAlertController.showAlert("Your spirit emoji must be an emoji character", message: nil, viewController: self)
      return
    }

    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    UserManager.changeUsername(username.toUnicode()) { (fault) in
      if fault != nil {
        UIAlertController.showAlertWithFault(fault, forVC: self)
      } else {
        self.navigationController?.popViewControllerAnimated(true)
      }
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }

    UserManager.saveSpiritEmoji(emojiString) { (fault) in
      if fault != nil {
        UIAlertController.showAlertWithFault(fault, forVC: self)
      } else {
        self.navigationController?.popViewControllerAnimated(true)
      }
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  }

  func navBarStyling() {
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.customBlueGreen(),
       NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 20)!]
    //    navigationController?.navigationBar.topItem?.title = ""
    navigationController?.viewControllers[0].title = "" //removes back button text
    title = "Edit Profile"
  }

}

extension EditProfileViewController: UITextFieldDelegate {
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }

    if string.toUnicode().characters.count == 24 && (textField.text?.isEmpty)! {
      return true
    }

    let newLength = text.characters.count + string.characters.count - range.length
    print(string.toUnicode())
    return newLength <= 1 // Bool
  }
}

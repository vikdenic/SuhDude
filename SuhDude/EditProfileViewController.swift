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
    navBarStyling()

    username = backendless.userService.currentUser.name
    if String(backendless.userService.currentUser.getProperty("spiritEmoji")).fromUnicode().containsEmoji() {
      emojiString = String(backendless.userService.currentUser.getProperty("spiritEmoji")).fromUnicode()
    }
    setUpForm()
  }

  //MARK: Eureka Form
  func setUpForm() {
    form +++ Section(footer:"Spirit emojis appear next to a user's name")

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
    } else if !emojiString.containsEmoji() {
      UIAlertController.showAlert("Your spirit emoji must be an emoji character", message: nil, viewController: self)
      return
    } else if emojiString.characters.count > 1 {
      UIAlertController.showAlert("Your spirit emoji must be one emoji character", message: nil, viewController: self)
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
    title = "Edit Profile"
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: UIColor.whiteColor(),
       NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 20)!]
    navigationController?.navigationBar.topItem?.title = ""

    saveBarButton.setTitleTextAttributes([
      NSFontAttributeName : UIFont(name: "AvenirNext-DemiBold", size: 18)!],
                                                              forState: UIControlState.Normal)
  }

}

extension EditProfileViewController: UITextFieldDelegate {
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }

    let newLength = text.characters.count + string.characters.count - range.length
    return newLength <= 1 // Bool
  }
}

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

  override func viewDidLoad() {
    super.viewDidLoad()

    username = backendless.userService.currentUser.name
    navBarStyling()
    setUpForm()
  }

  //MARK: Eureka Form
  func setUpForm() {
    form +++ Section()

      <<< TextRow() {
        $0.title = "username"
        $0.value = username
        }.onChange { [weak self] row in
          self?.username = row.value
          print(row.value)
    }
  }

  @IBAction func onSaveButtonTapped(sender: AnyObject) {
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    UserManager.changeUsername(username) { (fault) in
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

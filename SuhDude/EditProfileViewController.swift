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

  override func viewDidLoad() {
    super.viewDidLoad()
    navBarStyling()
    setUpForm()
  }

  //MARK: Eureka Form
  func setUpForm() {

    form +++ Section()

      <<< TextRow() {
        $0.title = "username"
        $0.value = backendless.userService.currentUser.name
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

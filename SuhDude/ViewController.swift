//
//  ViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/3/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let backendless = Backendless.sharedInstance()
    let user: BackendlessUser = BackendlessUser()
    user.email = "michael@backendless.com"
    user.password = "my_super_password"
    backendless.userService.registering(user)
  }

}


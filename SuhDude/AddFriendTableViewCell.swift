//
//  AddFriendTableViewCell.swift
//  SuhDude
//
//  Created by Vik Denic on 3/8/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class AddFriendTableViewCell: UITableViewCell {

  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var addImageView: UIImageView!

  var user: BackendlessUser! {
    didSet {
      setUpCell()
    }
  }

  func setUpCell() {
    usernameLabel.text = user.name

    if user.getProperty("selected").boolValue == true {
      addImageView.image = UIImage(named: "checkCircle")
    } else {
      addImageView.image = UIImage(named: "addCircle")
    }
  }

}

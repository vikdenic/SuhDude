//
//  MainTableViewCell.swift
//  SuhDude
//
//  Created by Vik Denic on 3/23/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var deliveryImageView: UIImageView!
  @IBOutlet var dateLabel: UILabel!

  var friendship: Friendship! {
    didSet {
      setUpCell()
    }
  }

  func setUpCell() {
    usernameLabel.text = friendship.friend().name
  }

}

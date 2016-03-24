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

  let kImageSent = "sentImage"
  let kImageReceived = "receivedImage"

  var friendship: Friendship! {
    didSet {
      setUpCell()
    }
  }

  func setUpCell() {
    usernameLabel.text = friendship.friend().name

    if let lastSender = friendship.recentSender {
      deliveryImageView.image = lastSender.isCurrentUser() ? UIImage(named: kImageSent) : UIImage(named: kImageReceived)
    } else {
      deliveryImageView.image = nil
    }

    if let lastSent = friendship.lastSent {
      dateLabel.text = lastSent.timeAgoSinceDate(true)
    } else {
      dateLabel.text = ""
    }
  }

}

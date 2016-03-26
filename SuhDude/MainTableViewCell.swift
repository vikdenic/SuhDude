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
  @IBOutlet var spinner: UIActivityIndicatorView!

  var isLoading = false

  let kImageSent = "planeImage"
  let kImageReceived = "receivedImage"
  let kImageTap = "tapImage"

  var friendship: Friendship! {
    didSet {
      setUpCell()
    }
  }

  func setUpCell() {
    configureLoadingState()
    usernameLabel.text = friendship.friend().name

    if let lastSender = friendship.recentSender {
      deliveryImageView.image = lastSender.isCurrentUser() ? UIImage(named: kImageSent) : UIImage(named: kImageReceived)
    } else {
      deliveryImageView.image = nil
    }

    if let lastSent = friendship.lastSent {
      dateLabel.text = lastSent.timeAgoSinceDate(true)
    } else {
      dateLabel.text = "Tap to send"
    }
  }

  func configureLoadingState() {
    if isLoading {
      deliveryImageView.hidden = true
      spinner.startAnimating()
      return
    }
    spinner.stopAnimating()
    deliveryImageView.hidden = false
  }

}

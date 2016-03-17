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
  @IBOutlet var spinner: UIActivityIndicatorView!

  var isLoading = false

  var user: BackendlessUser! {
    didSet {
      setUpCell()
    }
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    spinner.stopAnimating()
    addImageView.hidden = false
    if !selected {
      addImageView.image = UIImage(named: "addCircle")
    } else {
      addImageView.image = UIImage(named: "checkCircle")
    }
  }

  func setUpCell() {
    usernameLabel.text = user.name
    configureSelectedState()
  }

  func configureSelectedState() {
    if !isLoading {
      spinner.startAnimating()
      addImageView.hidden = false

      if !selected {
        addImageView.image = UIImage(named: "addCircle")
      } else {
        addImageView.image = UIImage(named: "checkCircle")
      }

    } else {
      spinner.startAnimating()
      addImageView.hidden = true
    }
  }

}
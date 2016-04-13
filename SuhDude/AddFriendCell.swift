//
//  AddFriendTableViewCell.swift
//  SuhDude
//
//  Created by Vik Denic on 3/8/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

protocol AddFriendCellDelegate
{
  func didTapAddButton(button : UIButton, user : BackendlessUser)
}

class AddFriendCell: UITableViewCell {

  var delegate = AddFriendCellDelegate?()

  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var spinner: UIActivityIndicatorView!
  @IBOutlet var addButton: UIButton!
    
  var isLoading = false
  var added = false

  var user: BackendlessUser! {
    didSet {
      setUpCell()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    bringSubviewToFront(addButton)
  }

  func setUpCell() {
    usernameLabel.text = user.name
    configureSelectedState()
  }

  func configureSelectedState() {

    addButton.hidden = true

    if isLoading {
      spinner.startAnimating()
      return
    } else {
      spinner.stopAnimating()
    }

    if selected {
      addButton.hidden = false
      addButton.setBackgroundImage(UIImage(named: "checkCircle"), forState: .Normal)
    } else {
      addButton.hidden = false
      addButton.setBackgroundImage(UIImage(named: "addCircle"), forState: .Normal)
    }
  }

  @IBAction func onAddButtonTapped(sender: UIButton) {
    delegate?.didTapAddButton(sender, user: user)
  }
}
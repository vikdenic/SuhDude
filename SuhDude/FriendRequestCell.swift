//
//  FriendRequestCell.swift
//  SuhDude
//
//  Created by Vik Denic on 4/9/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

protocol FriendRequestCellDelegate
{
  func didTapApproveButton(button : UIButton)
  func didTapDeclineButton(button : UIButton)
}

class FriendRequestCell: UITableViewCell {

  var delegate = FriendRequestCellDelegate?()

  @IBOutlet var usernameLabel: UILabel!
  @IBOutlet var approveButton: UIButton!
  @IBOutlet var declineButton: UIButton!

  var friendship: Friendship! {
    didSet {
      setUpCell()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    bringSubviewToFront(approveButton)
    bringSubviewToFront(declineButton)
  }

  func setUpCell() {
    usernameLabel.text = friendship.friend().name
  }

  @IBAction func onApproveButtonTapped(sender: UIButton) {
    delegate?.didTapApproveButton(sender)
  }

  @IBAction func onDeclineButtonTapped(sender: UIButton) {
    delegate?.didTapDeclineButton(sender)
  }

}

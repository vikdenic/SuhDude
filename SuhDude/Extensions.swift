//
//  Extensions.swift
//  SuhDude
//
//  Created by Vik Denic on 3/5/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import Foundation

extension UIAlertController {
  class func showAlert(title : String!, message : String!, viewController : UIViewController)
  {
    let alert : UIAlertController = UIAlertController(title: title,
      message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style:.Default, handler: nil))
    viewController.presentViewController(alert, animated: true, completion: nil)
  }

  class func showAlertWithError(error : NSError!, forVC : UIViewController)
  {
    let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(okAction)
    forVC.presentViewController(alert, animated: true, completion: nil)
  }

  class func showAlertWithFault(fault : Fault!, forVC : UIViewController)
  {
    let alert = UIAlertController(title: fault.message, message: nil, preferredStyle: .Alert)
    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(okAction)
    forVC.presentViewController(alert, animated: true, completion: nil)
  }
}

let kPermittedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"

extension String {
  /**
   - returns: a Bool value representing whether or not the String only contains allowed characters (alphanumerics and underscores)
   */
  func containsValidCharacters() -> Bool {

    var charSet = NSCharacterSet(charactersInString: kPermittedCharacters)
    charSet = charSet.invertedSet

    let range = (self as NSString).rangeOfCharacterFromSet(charSet)

    if range.location != NSNotFound {
      return false
    }

    return true
  }
}

extension Array {
  func arrayWithoutFriends(var friends : [BackendlessUser]) -> [BackendlessUser] {
    let backendless = Backendless.sharedInstance()
    friends.append(backendless.userService.currentUser)

    var friendObjIds = [String]()

    for friend in friends {
      friendObjIds.append(friend.objectId)
    }

    var nonFriends = [BackendlessUser]()
    for user in self {
      if friendObjIds.contains((user as! BackendlessUser).objectId) { }
      else {
        nonFriends.append(user as! BackendlessUser)
      }
    }
    return nonFriends
  }

  func arrayWithoutCurrentUser() -> [BackendlessUser] {
    let backendless = Backendless.sharedInstance()

    var newArray = [BackendlessUser]()

    for user in self {
      if (user as! BackendlessUser).objectId == backendless.userService.currentUser.objectId { }
      else {
        newArray.append(user as! BackendlessUser)
      }
    }

    return newArray
  }
}

extension UINavigationController {
  func setNavBarToClear() {
    self.navigationBarHidden = false
    self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    self.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.translucent = true
    self.view.backgroundColor = UIColor.clearColor()
  }
}
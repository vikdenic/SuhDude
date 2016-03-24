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
  /**
   - returns: an array of users that are not a part of any (non-group) friendship with the current user (i.e. non-friends)
   */
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

  /**
   - returns: an array of users, sans the current user
   */
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

  /**
   - returns: an array of users from an array of friendship's members' properties (excluding the current user)
   */
  func arrayOfFriends() -> [BackendlessUser] {
    let backendless = Backendless.sharedInstance()
    var friends = [BackendlessUser]()

    for friendship in self {
      for user in (friendship as! Friendship).members! {
        if user.objectId != backendless.userService.currentUser.objectId {
          friends.append(user)
        }
      }
    }
    return friends
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

extension NSDate {
  func timeAgoSinceDate(numericDates:Bool) -> String {
    let calendar = NSCalendar.currentCalendar()
    let now = NSDate()
    let earliest = now.earlierDate(self)
    let latest = (earliest == now) ? self : now
    let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())

    if (components.year >= 2) {
      return "\(components.year) years ago"
    } else if (components.year >= 1){
      if (numericDates){
        return "1 year ago"
      } else {
        return "Last year"
      }
    } else if (components.month >= 2) {
      return "\(components.month) months ago"
    } else if (components.month >= 1){
      if (numericDates){
        return "1 month ago"
      } else {
        return "Last month"
      }
    } else if (components.weekOfYear >= 2) {
      return "\(components.weekOfYear) weeks ago"
    } else if (components.weekOfYear >= 1){
      if (numericDates){
        return "1 week ago"
      } else {
        return "Last week"
      }
    } else if (components.day >= 2) {
      return "\(components.day) days ago"
    } else if (components.day >= 1){
      if (numericDates){
        return "1 day ago"
      } else {
        return "Yesterday"
      }
    } else if (components.hour >= 2) {
      return "\(components.hour) hours ago"
    } else if (components.hour >= 1){
      if (numericDates){
        return "1 hour ago"
      } else {
        return "An hour ago"
      }
    } else if (components.minute >= 2) {
      return "\(components.minute) minutes ago"
    } else if (components.minute >= 1){
      if (numericDates){
        return "1 minute ago"
      } else {
        return "A minute ago"
      }
    } else if (components.second >= 3) {
      return "\(components.second) seconds ago"
    } else {
      return "Just now"
    }
    
  }

}
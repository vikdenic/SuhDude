//
//  Extensions.swift
//  SuhDude
//
//  Created by Vik Denic on 3/5/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import Foundation

let kNotifPushReceived = "pushReceived"
let kDefaultsMuted = "muted"

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

extension UIColor {
  class func customBlueGreen() -> UIColor {
    return UIColor(red: 14, green: 178, blue: 198, alpha: 1.0)
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

  func emoIsPureEmoji() -> Bool {
    return (self as NSString).emo_isPureEmojiString()
  }

  func toUnicode() -> String {
    let data = self.dataUsingEncoding(NSNonLossyASCIIStringEncoding)
    return NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
  }

  func fromUnicode() -> String {
    let data = self.dataUsingEncoding(NSUTF8StringEncoding)
    return NSString(data: data!, encoding: NSNonLossyASCIIStringEncoding)! as String
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

  /**
   Moves an object at the specified index of an array to a new index of that array

   - parameter oldIndex: the index of the object to move
   - parameter newIndex: the index to which the object will be moved to
   */
  mutating func moveItem(fromIndex oldIndex: Index, toIndex newIndex: Index) {
    insert(removeAtIndex(oldIndex), atIndex: newIndex)
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

extension BackendlessUser {
  func isCurrentUser() -> Bool {
    let backendless = Backendless.sharedInstance()

    if self.objectId == backendless.userService.currentUser.objectId {
      return true
    }
    return false
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
      return "\(components.year)y ago"
    } else if (components.year >= 1){
      if (numericDates){
        return "Last year"
      } else {
        return "Last year"
      }
    } else if (components.month >= 2) {
      return "\(components.month) months ago"
    } else if (components.month >= 1){
      if (numericDates){
        return "Last month"
      } else {
        return "Last month"
      }
    } else if (components.weekOfYear >= 2) {
      return "\(components.weekOfYear)wks ago"
    } else if (components.weekOfYear >= 1){
      if (numericDates){
        return "Last week"
      } else {
        return "Last week"
      }
    } else if (components.day >= 2) {
      return self.toAbbrevDayString()
//      return "\(components.day) days ago"
    } else if (components.day >= 1){
      if (numericDates){
        return "Yesterday"
      } else {
        return "Yesterday"
      }
    } else if (components.hour >= 2) {
      return self.toAbbrevTimeString()
//      return "\(components.hour)h ago"
    } else if (components.hour >= 1){
      if (numericDates){
        return "1h ago"
      } else {
        return "An hour ago"
      }
    } else if (components.minute >= 2) {
      return "\(components.minute)m ago"
    } else if (components.minute >= 1){
      if (numericDates){
        return "1m ago"
      } else {
        return "A minute ago"
      }
    } else if (components.second >= 3) {
      return "\(components.second)s ago"
    } else {
      return "Just now"
    }
    
  }

  func toAbbrevTimeString() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "h:mm a"
    let localTZ = NSTimeZone.localTimeZone()
    formatter.timeZone = localTZ
    return formatter.stringFromDate(self)
  }

  func toAbbrevDayString() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "E"
    let localTZ = NSTimeZone.localTimeZone()
    formatter.timeZone = localTZ
    return formatter.stringFromDate(self)
  }

}
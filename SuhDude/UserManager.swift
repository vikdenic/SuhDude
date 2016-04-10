//
//  User.swift
//  SuhDude
//
//  Created by Vik Denic on 3/5/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import Foundation

class UserManager {

  class func retrieveAllUsers(completed : ((users : [BackendlessUser]?, fault : Fault?) -> Void)?) {
    let backendless = Backendless.sharedInstance()
    let query = BackendlessDataQuery()
    // Use backendless.persistenceService to obtain a ref to a data store for the class

    let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass()) as IDataStore
    dataStore.find(query, response: { (retrievedCollection) -> Void in
      print("Successfully retrieved collection")
      completed!(users: retrievedCollection.data as? [BackendlessUser], fault: nil)
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
        completed!(users: nil, fault: fault)
    }
  }

  class func retrieveCurrentUsersFriends(completed : (users : [BackendlessUser]?, fault : Fault?) -> Void) {
    let backendless = Backendless.sharedInstance()

    Friendship.retrieveFriendshipsForUser(backendless.userService.currentUser, approved: true) { (friendships, fault) -> Void in

      guard let friendships = friendships else {
        print("No friendships retrieved w/ error: \(fault)")
        completed(users: nil, fault: fault)
        return
      }

      var friends = [BackendlessUser]()
      for ship in friendships {
        for member in ship.members! {
          if member.objectId != backendless.userService.currentUser.objectId {
            friends.append(member)
          }
        }
      }
      print("Successfully retrieved \(friends.count) friends")
      completed(users: friends, fault: fault)
    }
  }

  class func retrieveNonFriends(completed : (users : [BackendlessUser]?, fault : Fault?) -> Void) {
    UserManager.retrieveAllUsers { (users, fault) -> Void in
      guard let users = users else {
        print("Server reported an error: \(fault)")
        completed(users: nil, fault: fault)
        return
      }

      UserManager.retrieveCurrentUsersFriends({ (friends, fault) -> Void in
        guard let friends = friends else {
          print("Server reported an error: \(fault)")
          completed(users: nil, fault: fault)
          return
        }

        let nonFriends = users.arrayWithoutFriends(friends)
        completed(users: nonFriends, fault: fault)
      })
    }
  }
  
  class func fetchUser(objectId : String, completed : (user : BackendlessUser?, fault : Fault!) -> Void) {
    let backendless = Backendless.sharedInstance()

    let dataStore = backendless.data.of(BackendlessUser.ofClass())

    dataStore.findID(objectId, response: { (user) -> Void in
      completed(user: user as? BackendlessUser, fault: nil)
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
        completed(user: nil, fault: fault)
    }
  }

  class func changeUsername(name : String, completed : (fault : Fault?) -> Void) {
    let backendless = Backendless.sharedInstance()

    backendless.userService.currentUser.name = name

    backendless.userService.update(backendless.userService.currentUser, response: { (updatedUser) in
      completed(fault: nil)
      }) { (fault) in
      completed(fault: fault)
    }
  }

  class func saveSpiritEmoji(emojiString : String, completed : (fault : Fault?) -> Void) {
    let backendless = Backendless.sharedInstance()

    backendless.userService.currentUser.setProperty("spiritEmoji", object: emojiString.toUnicode())

    backendless.userService.update(backendless.userService.currentUser, response: { (updatedUser) in
      completed(fault: nil)
    }) { (fault) in
      completed(fault: fault)
    }
  }

}
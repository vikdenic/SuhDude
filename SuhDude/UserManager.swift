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

  class func retrieveAllUsers(withNameLike name : String, completed : ((users : [BackendlessUser]?, fault : Fault?) -> Void)?) {
    let backendless = Backendless.sharedInstance()
    let query = BackendlessDataQuery()
    // Use backendless.persistenceService to obtain a ref to a data store for the class

    let whereClause = "name LIKE '%\(name)%'"

    query.whereClause = whereClause

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
      print("Successfully retrieved \(friends.count) friends for current user")
      completed(users: friends, fault: fault)
    }
  }

  class func retrieveFriendsForUser(user : BackendlessUser, completed : (users : [BackendlessUser]?, fault : Fault?) -> Void) {
    let backendless = Backendless.sharedInstance()

    Friendship.retrieveFriendshipsForUser(user, approved: true) { (friendships, fault) -> Void in

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
      print("Successfully retrieved \(friends.count) friends for other user")
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

  class func retrieveNonFriendsOfFriends(completed : (users : [BackendlessUser]?, fault : Fault?) -> Void) {

    var allNonFriends = [BackendlessUser]()
    let downloadGroup = dispatch_group_create() // 2

    dispatch_group_enter(downloadGroup) // 3
    UserManager.retrieveCurrentUsersFriends { (users, fault) in

      defer {
        // Whether we return early or use the users we want to leave the group
        // Balances the initial enter()
        dispatch_group_leave(downloadGroup)
      }

      for user in users! {
        dispatch_group_enter(downloadGroup) // 3
        UserManager.retrieveFriendsForUser(user, completed: { (usersFriends, fault) in
          // No matter the outcome of the call we want to leave the
          // dispatch_group so we don't wait forever
          defer {
            // Balances the enter() for each user
            dispatch_group_leave(downloadGroup)
          }
          let nonFriends = usersFriends!.arrayWithoutFriends(users!)
          allNonFriends += nonFriends
        })
      }
    }

    dispatch_group_notify(downloadGroup, dispatch_get_main_queue()) { 
      completed(users: (allNonFriends as NSArray).arrayWithoutObjectsOfDuplicateProperty("name") as? [BackendlessUser], fault: nil)
    }

//    dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
//    completed(users: allNonFriends, fault: nil)
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
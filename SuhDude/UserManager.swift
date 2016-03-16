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

  class func retrieveCurrentUsersFriends(completed : ((users : [BackendlessUser]?, fault : Fault?) -> Void)?) {
    let backendless = Backendless.sharedInstance()

    UserManager.retrieveAllUsers { (users, fault) -> Void in
      guard let users = users else { return }

//      Friendship.retrieveAllFriendships({ (friendships, fault) -> Void in
//        guard let friendships = friendships else { return }
//        var friends = [BackendlessUser]()
//
////        for friendship in friendships {
////          let members = friendship.members! as [BackendlessUser]
////
////          for member in members {
////            if member.objectId != backendless.userService.currentUser.objectId {
////              friends.append(member)
////            }
////          }
////        }
////        print("friends are: ")
////        for friend in friends {
////          print(friend.name)
////        }
//      })
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
}
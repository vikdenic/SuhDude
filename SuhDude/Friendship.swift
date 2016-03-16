//
//  Friendship.swift
//  TestApp
//
//  Created by MP on 3/13/16.
//  Copyright © 2016 MP. All rights reserved.
//

import Foundation

class Friendship: NSObject {
  var objectId: String?
  var ownerId: String?
  var created: NSDate?
  var members: [BackendlessUser]?

  var suhCount: Int = 0
  var sendPush: Bool = false
  var lastSent: NSDate?
  var lastSender: BackendlessUser?
  var group: Bool = false

  init(members: [BackendlessUser]) {
    self.members = members
    super.init()
  }

  override init() {
    super.init()
  }

  class func loadWithRelations() {
    let backendless = Backendless.sharedInstance()
    let query = BackendlessDataQuery()

    //retrieves related objects
    let queryOptions = QueryOptions()
    queryOptions.related = ["members", "members.friends"];
    query.queryOptions = queryOptions

    let dataStore = backendless.persistenceService.of(Friendship.ofClass()) as IDataStore
    dataStore.find(query, response: { (retrievedCollection) -> Void in
      print("Successfully retrieved friendships")
      for friendship in retrievedCollection.getCurrentPage() as! [Friendship] {
        print("friendship = \(friendship.objectId)")
      }
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
    }
  }

  class func retrieveAllFriendships() {
    let backendless = Backendless.sharedInstance()
    let query = BackendlessDataQuery()

    //retrieves related objects
    let queryOptions = QueryOptions()
    queryOptions.related = ["members"];
    query.queryOptions = queryOptions

    let dataStore = backendless.persistenceService.of(Friendship.ofClass()) as IDataStore
    dataStore.find(query, response: { (retrievedCollection) -> Void in
      print("Successfully retrieved friendships")
      //completed(friendships: retrievedCollection.data as? [Friendship], fault: nil)
      let friendships = retrievedCollection.data as? [Friendship];
      print( "friendships \(friendships)")
      for friendship in friendships! {
        print("friendship = \(friendship.objectId)")
      }
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
        //  completed(friendships: nil, fault: fault)
    }
  }



  func save(completed : (fault : Fault!) -> Void) {
    let backendless = Backendless.sharedInstance()

    backendless.persistenceService.of(Friendship.ofClass()).save(self, response: { (savedFriendship) -> Void in
      print("successfully saved friendship")
      completed(fault: nil)
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
        completed(fault: fault)
    }
  }
}
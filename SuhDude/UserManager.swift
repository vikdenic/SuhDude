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

  class func saveUserWithDeviceId(completed : (fault : Fault?) -> Void) {
    let backendless = Backendless.sharedInstance()
    let currentUser = Backendless.sharedInstance().userService.currentUser

    currentUser.setProperty("deviceId", object: backendless.messagingService.currentDevice().deviceId)

    backendless.userService.update(currentUser, response: { (updatedUser) -> Void in
        print("Successfully updated user: \(currentUser)")
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
    }
  }

  class func saveUserAndClearDeviceId(completed : (fault : Fault?) -> Void) {
    let backendless = Backendless.sharedInstance()
    let currentUser = Backendless.sharedInstance().userService.currentUser

    currentUser.setProperty("deviceId", object: nil)

    backendless.userService.update(currentUser, response: { (updatedUser) -> Void in
      print("Successfully updated user: \(currentUser)")
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
    }
  }

}
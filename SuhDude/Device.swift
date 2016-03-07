//
//  Device.swift
//  SuhDude
//
//  Created by Vik Denic on 3/5/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit

class Device: NSObject {
  var objectId: String?
  var deviceId: String?
  var user: BackendlessUser?

  // Initialize from arbitrary data
  init(deviceId: String, user: BackendlessUser) {
    self.deviceId = deviceId
    self.user = user
    super.init()
  }

  override init() {
    super.init()
  }

  func save(completed : (success : Bool, fault : Fault!) -> Void) {
    let backendless = Backendless.sharedInstance()

    backendless.persistenceService.of(Device.ofClass()).save(self, response: { (savedDevice) -> Void in
        print("successfully saved device: \(savedDevice)")
        completed(success: true, fault: nil)
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
        completed(success: false, fault: fault)
    }
  }
}

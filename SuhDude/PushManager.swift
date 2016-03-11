//
//  PushManager.swift
//  SuhDude
//
//  Created by Vik Denic on 3/6/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import Foundation

class PushManager {

  class func publishMessageAsPushNotificationAsync(message: String, channel: String) {
    let backendless = Backendless.sharedInstance()

    let deliveryOptions = DeliveryOptions()
    deliveryOptions.pushBroadcast(FOR_ALL)
    deliveryOptions.pushPolicy(PUSH_ONLY)

    let publishOptions = PublishOptions()
    publishOptions.headers = ["ios-sound":"suhDude2NL.aif"]

    backendless.messaging.publish(channel, message: message, publishOptions:publishOptions, deliveryOptions:deliveryOptions,
      response:{ ( messageStatus : MessageStatus!) -> () in
        print("MessageStatus = \(messageStatus.status) ['\(messageStatus.messageId)']")
      },
      error: { ( fault : Fault!) -> () in
        print("Server reported an error: \(fault)")
      }
    )
  }

  class func cancelDeviceRegistrationAsync() {
    let backendless = Backendless.sharedInstance()

    backendless.messagingService.unregisterDeviceAsync({ (result) -> Void in
        print("Server reported a result: \(result)")
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
    }
  }
}
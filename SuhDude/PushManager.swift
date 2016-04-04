//
//  PushManager.swift
//  SuhDude
//
//  Created by Vik Denic on 3/6/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import Foundation

class PushManager {

  class func publishMessageAsPushNotificationAsync(message: String, channel: String, completed: (fault: Fault?) -> Void) {
    let backendless = Backendless.sharedInstance()

    let deliveryOptions = DeliveryOptions()
//    deliveryOptions.pushBroadcast(FOR_ALL)
    deliveryOptions.pushBroadcast(FOR_ALL.rawValue)
    deliveryOptions.pushPolicy(PUSH_ONLY)

    let publishOptions = PublishOptions()
    publishOptions.headers = ["ios-sound":"suhDude2NL.aif"]

    backendless.messaging.publish(channel, message: message, publishOptions:publishOptions, deliveryOptions:deliveryOptions,
      response:{ ( messageStatus : MessageStatus!) -> () in
        print("MessageStatus = \(messageStatus.status) ['\(messageStatus.messageId)']")
        completed(fault: nil)
      },
      error: { ( fault : Fault!) -> () in
        print("Server reported an error: \(fault)")
        completed(fault: fault)
      }
    )
  }

  class func registerForPush() {
      let application = UIApplication.sharedApplication()
      if application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
      } else {
        application.registerForRemoteNotificationTypes([.Badge, .Alert, .Sound])
      }
      application.registerForRemoteNotifications()
      NSUserDefaults.standardUserDefaults().setBool(false, forKey: kDefaultsMuted)
      NSUserDefaults.standardUserDefaults().synchronize()
  }

  class func cancelDeviceRegistrationAsync() {
    let backendless = Backendless.sharedInstance()

    backendless.messagingService.unregisterDeviceAsync({ (result) -> Void in
      print("Server reported a result: \(result)")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kDefaultsMuted)
        NSUserDefaults.standardUserDefaults().synchronize()
      }) { (fault) -> Void in
        print("Server reported an error: \(fault)")
    }
  }
}
//
//  AppDelegate.swift
//  SuhDude
//
//  Created by Vik Denic on 3/3/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  var backendless = Backendless.sharedInstance()
  let APP_ID = "FCC9E18B-C20B-0C59-FFE0-E931AC63F400"
  let SECRET_KEY = "8EB4108E-DCD3-CDAB-FF85-9BD80BD98000"
  let VERSION_NUM = "v1"

  var soundID: SystemSoundID = 0

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    backendless.userService.setStayLoggedIn(true)

    //TODO: Present this after user signs up
//    UIApplication.sharedApplication().registerForRemoteNotifications()

    return true
  }

  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

    backendless.messagingService.registerDeviceWithTokenData(deviceToken, response: { (deviceRegId) -> Void in

        //Two ways to associate User with deviceiD
        //A. Save deviceId to BackendlessUser
        UserManager.saveUserWithDeviceId({ (fault) -> Void in
          //TODO: Handle fault
        })

        //B. Save to custom Device object (graph of users and devices)
//        let device = Device(deviceId: self.backendless.messagingService.currentDevice().deviceId, user: self.backendless.userService.currentUser)
//
//        device.save { (success, fault) -> Void in
//          if fault != nil {
//            print("save Device failed w/ fault: \(fault)")
//
//          } else {
//            print("successfully saved Device w/ id: \(self.backendless.messagingService.currentDevice().deviceId)")
//          }
//        }
      }) { (fault) -> Void in
        //TODO: handle failed device registration
    }
  }

  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    playSoundWithUserInfo(userInfo)
  }

  func playSoundWithUserInfo(userInfo: [NSObject : AnyObject]) {
    let soundFileName = userInfo["ios-sound"] as! String
    let soundPath = NSBundle.mainBundle().pathForResource(soundFileName, ofType: nil)
    let fileURL = NSURL.fileURLWithPath(soundPath!) as CFURLRef
    AudioServicesCreateSystemSoundID(fileURL, &soundID)
    AudioServicesPlaySystemSound(soundID)
  }

  func applicationWillResignActive(application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}


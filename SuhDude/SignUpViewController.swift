//
//  SignUpViewController.swift
//  SuhDude
//
//  Created by Vik Denic on 3/5/16.
//  Copyright © 2016 nektur labs. All rights reserved.
//

import UIKit
import AudioToolbox

class SignUpViewController: UIViewController {

  @IBOutlet var loginBarButton: UIBarButtonItem!

  var loggingIn = false
  let kSegueSignUpToRegister = "signUpToRegister"

  var soundID: SystemSoundID = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
    navigationController?.setNavBarToClear()

    loginBarButton.setTitleTextAttributes([
      NSFontAttributeName : UIFont(name: "AvenirNext-DemiBold", size: 18)!],
      forState: UIControlState.Normal)
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    let value = UIInterfaceOrientation.Portrait.rawValue
    UIDevice.currentDevice().setValue(value, forKey: "orientation")
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    loggingIn = false
  }

  @IBAction func onLoginBarButtonTapped(sender: UIBarButtonItem) {
    loggingIn = true
    performSegueWithIdentifier(kSegueSignUpToRegister, sender: self)
  }

  @IBAction func onDefinitionTapped(sender: UIButton) {
    let soundFileName = "suhDude2NL.aif"
    let soundPath = NSBundle.mainBundle().pathForResource(soundFileName, ofType: nil)
    let fileURL = NSURL.fileURLWithPath(soundPath!) as CFURLRef
    AudioServicesCreateSystemSoundID(fileURL, &soundID)
    AudioServicesPlaySystemSound(soundID)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let registerVC = segue.destinationViewController as! RegisterUserViewController
    registerVC.loggingIn = loggingIn
  }

}

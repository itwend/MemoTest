//
//  PermissionViewController.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit
import AVFoundation

class PermissionViewController: UIViewController {

    @IBOutlet weak var permissionMicButton: UIButton!
    let appDelegate = AppDelegate.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.permissionMicButton.layer.cornerRadius = 6
    }

    @IBAction func permissionMicButtonTouchUp(_ sender: Any) {
        appDelegate.checkMicrophonePermission { () in
            DispatchQueue.main.async {
                self.appDelegate.auth.isFirstLaunch = true
                self.appDelegate.changeRootViewController()
            }
        }
    }
    
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.permissionMicButton.layer.cornerRadius = 6
    }

    @IBAction func permissionMicButtonTouchUp(_ sender: Any) {
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            
            if allowed {
                DispatchQueue.main.async {
                    self.changeRootViewController()
                }
            } else {
                
            }
        }
    }
    
    func changeRootViewController() {
        AppDelegate.instance.auth.isPermissionMic = true
        AppDelegate.instance.changeRootViewController()
    }

}

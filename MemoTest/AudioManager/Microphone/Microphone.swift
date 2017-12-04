//
//  Microphone.swift
//  MemoTest
//
//  Created by Andrew on 12/4/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

protocol MicrophoneDelegate {
    func showPermissionAlert()
}

class Microphone: NSObject {
    
    var delegate: MicrophoneDelegate?
    
    func checkMicrophonePermission(completion: (() -> Void)?) {
        AVAudioSession.sharedInstance().requestRecordPermission () {
           [unowned self] allowed in
            if !allowed {
                completion?()
                self.delegate?.showPermissionAlert()
            } else {
                completion?()
            }
        }
    }
    
}

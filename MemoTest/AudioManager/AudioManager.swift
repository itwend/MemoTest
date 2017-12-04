//
//  AudioManager.swift
//  MemoTest
//
//  Created by Andrew on 12/4/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: NSObject {
    
    fileprivate let audioSession = AVAudioSession.sharedInstance()

    override init() {
        super.init()
        setupAudioSession()
    }
    
    class func audioDuration(for resource: URL) -> Double {
        let asset = AVURLAsset(url: resource)
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    func setupAudioSession() {
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .mixWithOthers)
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            try audioSession.setActive(true)
        } catch {
            print("couldn't setup category \(error)")
        }
    }
    
}

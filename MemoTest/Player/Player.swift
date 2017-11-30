//
//  Player.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation
import AVFoundation

open class Player: NSObject {
    
    var audioPlayer: AVAudioPlayer!
    fileprivate let session = AVAudioSession.sharedInstance()

    public init(url: URL)  {
        super.init()
        preparePlayer(fileURL: url)
    }
    
    func setupSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .mixWithOthers)
            try audioSession.setActive(true)
        } catch {
            print("couldn't setup category \(error)")
        }
    }
    
    func play() {
//        if audioPlayer.isPlaying {
//            audioPlayer.pause()
//        } else {
            setupSession()
            audioPlayer.play()
        //}
    }
    
    func stop() {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
    }

    open func preparePlayer(fileURL: URL) {
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOf: fileURL)
        } catch {
            print("could not create AVAudioPlayer \(error)")
            return
        }
        audioPlayer.prepareToPlay()
        audioPlayer.volume = 1.0
    }
}

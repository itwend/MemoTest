//
//  Player.swift
//  MemoTest
//
//  Created by Andrew on 12/4/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation
import AVFoundation

protocol PlayerDelegate {
    func didFinishPlaying()
}

class Player: NSObject {
    
    @objc public enum StatePlayer: Int {
        case stop, play
    }
    
    var delegate: PlayerDelegate?
    var avPlayer: AVAudioPlayer?
    var state: StatePlayer = .stop
    
    init(state: StatePlayer) {
        self.state = state
        super.init()
    }
    
    func startPlay(filePath: URL) {
        do {
            avPlayer = try AVAudioPlayer(contentsOf: filePath)
            avPlayer?.delegate = self
            avPlayer?.play()
            state = .play
        } catch {
            print("couldn't load file")
        }
    }
    
    func stopPlay() {
        avPlayer?.stop()
        state = .stop
        delegate?.didFinishPlaying()
    }
    
}

extension Player: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.didFinishPlaying()
    }
    
}

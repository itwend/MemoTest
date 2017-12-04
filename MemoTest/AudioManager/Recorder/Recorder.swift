//
//  Recorder.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation
import AVFoundation

protocol RecorderDelegate {
    func didFinishRecording()
}

class Recorder: NSObject {
    
    @objc public enum StateRecorder: Int {
        case stop, record
    }
    
    var delegate: RecorderDelegate?
    var state: StateRecorder = .stop
    var avRecorder: AVAudioRecorder?
    var recordId: String?
    var recordUrl: URL?
    open var bitRate = 192000
    open var sampleRate = 44100.0
    open var channels = 1
    
    static var directory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    init(state: StateRecorder) {
        self.state = state
    }
    
    open func record(to: String ) throws {
        let url = URL(fileURLWithPath: Recorder.directory).appendingPathComponent(to)
        self.recordUrl = url
        let settings: [String: AnyObject] = [
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatAppleLossless) as Int32),
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey: bitRate as AnyObject,
            AVNumberOfChannelsKey: channels as AnyObject,
            AVSampleRateKey: sampleRate as AnyObject
        ]
        
        avRecorder = try AVAudioRecorder(url: url, settings: settings)
        avRecorder?.prepareToRecord()
        avRecorder?.record()
        state = .record
    }
    
    open func stop() {
        switch state {
        case .record:
            avRecorder?.stop()
            avRecorder = nil
            delegate?.didFinishRecording()
        default:
            break
        }
        state = .stop
    }
    
}

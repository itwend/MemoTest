//
//  Recorder.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation
import AVFoundation

open class Recorder: NSObject {
    
    @objc public enum StateRecorder: Int {
        case stopped, record
    }
    
    open fileprivate(set) var state: StateRecorder = .stopped
    fileprivate let session = AVAudioSession.sharedInstance()
    var recorder: AVAudioRecorder?
    
    open var bitRate = 192000
    open var sampleRate = 44100.0
    open var channels = 1
    
    static var directory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    public var url: URL {
        return URL(fileURLWithPath: Recorder.directory).appendingPathComponent("recording.m4a")
    }
    
    open func prepareRecorder() throws {
        let settings: [String: AnyObject] = [
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatAppleLossless) as Int32),
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey: bitRate as AnyObject,
            AVNumberOfChannelsKey: channels as AnyObject,
            AVSampleRateKey: sampleRate as AnyObject
        ]
        recorder = try AVAudioRecorder(url: url, settings: settings)
        recorder?.prepareToRecord()
    }
    
    open func record() throws {
        if recorder == nil {
            try prepareRecorder()
        }
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        recorder?.record()
        state = .record
    }
    
    open func stop() {
        switch state {
        case .record:
            recorder?.stop()
            
            do {
                let data = try Data(contentsOf: url)
                StorageDataSource.shared.saveSound(date: Date(), data: data, name: "Best Sound - Ever Never" , duration: Date())
                recorder = nil

            } catch {
                print("Unable to load data: \(error)")
            }
            
            
            
        default:
            break
        }
        state = .stopped
    }
}

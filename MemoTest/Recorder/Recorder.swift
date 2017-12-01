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

open class Recorder: NSObject {
    
    @objc public enum StateRecorder: Int {
        case stop, record
    }
    
    var delegate: RecorderDelegate?
    var state: StateRecorder = .stop
    fileprivate let session = AVAudioSession.sharedInstance()
    var recorder: AVAudioRecorder?
    open fileprivate(set) var recordUrl: URL
    var recordId: String?
    open var bitRate = 192000
    open var sampleRate = 44100.0
    open var channels = 1
    
    static var directory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    public init(to: String) {
        recordUrl = URL(fileURLWithPath: Recorder.directory).appendingPathComponent(to)
        super.init()
    }
    
    open func prepareRecorder() throws {
        let settings: [String: AnyObject] = [
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatAppleLossless) as Int32),
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey: bitRate as AnyObject,
            AVNumberOfChannelsKey: channels as AnyObject,
            AVSampleRateKey: sampleRate as AnyObject
        ]
        recorder = try AVAudioRecorder(url: recordUrl, settings: settings)
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
            recorder = nil
            delegate?.didFinishRecording()
        default:
            break
        }
        state = .stop
    }
    
}

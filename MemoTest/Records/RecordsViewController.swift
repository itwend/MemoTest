//
//  ViewController.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var startRecordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var recorder: Recorder!
    var player: Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Memos"
        recordView.layer.cornerRadius = 4
        createRecorder()
        
        print("url = \(recorder.url)")
        
    }
    
    func createRecorder() {
        recorder = Recorder()
        DispatchQueue.global().async {
            do {
                try self.recorder.prepareRecorder()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func startRecordButtonTouchUp(_ sender: Any) {
        do {
            try recorder.record()
        } catch {
            print(error)
        }
    }
    
    @IBAction func stopRecordButtonTouchUp(_ sender: Any) {
        recorder.stop()
    }

    @IBAction func playAudioButtonTouchUp(_ sender: Any) {
        
        player = Player.init(url: recorder.url)
        print("url = \(recorder.url)")

        player.play()
    }
}

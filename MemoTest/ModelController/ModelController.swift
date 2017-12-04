//
//  ModelController.swift
//  MemoTest
//
//  Created by Andrew on 12/4/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation

class ModelController {
    
    var player = Player(state: .stop)
    var recorder = Recorder(state: .stop)
    var fileSteer = FileSteer()
    var microphone = Microphone()
    
}

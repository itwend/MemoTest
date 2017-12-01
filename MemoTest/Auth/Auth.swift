//
//  Auth.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation

class Auth {
    
    let defaults = UserDefaults.standard
    static let firstLaunch = "firstLaunch"

    var isFirstLaunch: Bool {
        set {
            defaults.set(newValue, forKey: Auth.firstLaunch)
            defaults.synchronize()
        }
        get {
            return defaults.bool(forKey: Auth.firstLaunch)
        }
    }
    
}



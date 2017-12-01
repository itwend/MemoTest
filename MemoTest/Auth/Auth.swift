//
//  Auth.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation

let firstLaunch = "firstLaunch"

class Auth {
    
    let defaults = UserDefaults.standard
    
    var isFirstLaunch: Bool {
        set {
            defaults.set(newValue, forKey: firstLaunch)
            defaults.synchronize()
        }
        get {
            if let _ =  defaults.value(forKey: firstLaunch) {
                return defaults.value(forKey: firstLaunch) as! Bool
            }
            return false
        }
    }
}



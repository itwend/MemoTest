//
//  Auth.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation

let permission = "permissionMicrophone"

class Auth {
    
    let defaults = UserDefaults.standard
    
    var isPermissionMic: Bool {
        set {
            defaults.set(newValue, forKey: permission)
            defaults.synchronize()
        }
        get {
            if let _ =  defaults.value(forKey: permission) {
                return defaults.value(forKey: permission) as! Bool
            }
            return false
        }
    }
}



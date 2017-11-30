//
//  FieldsValidator.swift
//  MemoTest
//
//  Created by Andrew on 11/29/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation

extension String {
    
    var trimmedString: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isValidSoundNameLength: Bool {
        return NSLocationInRange(trimmedString.count, NSMakeRange(1, 100))
    }
    
}

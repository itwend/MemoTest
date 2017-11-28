//
//  UIColor+String.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func rgbStringToUIColor (_ rgb:String) -> UIColor {
        var colorArray: [String]
        var cString:String = rgb.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("RGB") {
            cString = cString.replacingOccurrences(of: "RGB", with: "")
            cString = cString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines as CharacterSet)
        }
        if rgb.contains(",") {
            colorArray = rgb.split{$0 == ","}.map(String.init)
        }
        else if rgb.contains(".") {
            colorArray = rgb.split{$0 == "."}.map(String.init)
        }
        else if rgb.contains("/") {
            colorArray = rgb.split{$0 == "/"}.map(String.init)
        }
        else if rgb.contains("|") {
            colorArray = rgb.split{$0 == "|"}.map(String.init)
        }
        else {
            colorArray = rgb.split{$0 == " "}.map(String.init)
        }
        return UIColor(
            red: cgFloatFromString(colorArray[0]) / 255.0,
            green: cgFloatFromString(colorArray[1]) / 255.0,
            blue: cgFloatFromString(colorArray[2]) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func cgFloatFromString(_ string: String) -> CGFloat {
        let newString = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines as CharacterSet)
        return CGFloat((newString as NSString).floatValue)
    }
}

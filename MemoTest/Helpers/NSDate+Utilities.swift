//
//  NSDate+Utilities.swift
//  MemoTest
//
//  Created by Andrew on 12/1/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation

extension Date {
    
    public static func dateWithDayMonthYear(date: Date) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.dateFormat = "dd MMM EEEE"
        let newDate = dateFormatter1.string(from: date )
        return newDate
    }
    
    public static func dateWithTime24(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateFormat = "HH:mm"
        let newDate = dateFormatter.string(from: date )
        return newDate
    }
}

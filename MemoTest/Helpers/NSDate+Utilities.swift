//
//  NSDate+Utilities.swift
//  MemoTest
//
//  Created by Andrew on 12/1/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation

extension Date {
    
    public static func dateWithDayMonthYearTime(date: Date) -> String {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .full
        dateFormatter1.dateFormat = "dd MMM, yyyy, HH:mm"
        let newDate = dateFormatter1.string(from: date )
        return newDate
    }
    
}

//
//  StorageDataSource.swift
//  MemoTest
//
//  Created by Andrew on 11/29/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class StorageDataSource: NSObject {
    
    static let shared = StorageDataSource()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sounds: [Sound] = []

    func saveSound(date: Date, data: Data, name: String, duration: Date) {
        let sound = Sound(context: context)
        sound.date = date
        sound.data = data
        sound.duration = duration
        sound.name = name
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func removeSound(indexPath: IndexPath) {
        let route = sounds[indexPath.row]
        context.delete(route)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

}

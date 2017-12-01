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

    func saveSound(record: Record) {
        let sound = Sound(context: context)
        sound.date = record.date
        sound.duration = record.duration
        sound.name = record.name
        sound.id = record.id
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func removeSound(_ sound: Sound) {
        context.delete(sound)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}

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

    func saveSound(date: Date, name: String, duration: Date, id: String) {
        let sound = Sound(context: context)
        sound.date = date
        sound.duration = duration
        sound.name = name
        sound.id = id
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func removeSound(_ sound: Sound) {
        context.delete(sound)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

}

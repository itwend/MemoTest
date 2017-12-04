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
    
    static let persistentName = "MemoTest"
    static let shared = StorageDataSource()
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    func saveSound(record: Record) {
        let sound = Sound(context: context)
        sound.date = record.date
        sound.duration = record.duration
        sound.name = record.name
        sound.id = record.id
        saveContext()
    }
    
    func removeSound(_ sound: Sound) {
        context.delete(sound)
        saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: StorageDataSource.persistentName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

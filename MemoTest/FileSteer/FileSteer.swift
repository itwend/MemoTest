//
//  FileManager.swift
//  MemoTest
//
//  Created by Andrew on 12/4/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import Foundation

class FileSteer {
    
    let fileManager = FileManager.default
    
    func documentsDirectory() -> String {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return ""
        }
        return "\(dirPath)/"
    }
    
    func removeFileFromDirectory(_ id: String ,completion: (() -> Void)?) {
        let filePath = documentsDirectory() + id
        do {
            try fileManager.removeItem(atPath: filePath)
            completion?()
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
}

//
//  AppDelegate.swift
//  MemoTest
//
//  Created by Andrew on 11/28/17.
//  Copyright © 2017 Andrew Gerbovtsan. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var auth = Auth()
    var window: UIWindow?
    static let persistentName = "MemoTest"
    static var instance = UIApplication.shared.delegate as! AppDelegate
    var microphonePermssonCallBack : ((_ allowed: Bool) -> Void)?
    
    lazy var authViewController: UIViewController = {
        let viewController = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
        return viewController ?? UIViewController()
    }()
    
    lazy var mainViewController: UIViewController = {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        return viewController ?? UIViewController()
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        changeRootViewController()
        return true
    }
    
    func changeRootViewController() {
        
        if auth.isFirstLaunch {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "RecordsViewController") as! RecordsViewController
            let navVC = NavigationController.init(rootViewController: controller)
            self.window?.rootViewController = navVC
            if controller.managedObjectContext == nil {
                controller.managedObjectContext = self.persistentContainer.viewContext
            }
            checkMicrophonePermission(completion: nil)
        } else {
            let authStoryboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let controller = authStoryboard.instantiateViewController(withIdentifier: "PermissionViewController") as! PermissionViewController
            let navVC = NavigationController.init(rootViewController: controller)
            self.window?.rootViewController = navVC
        }
        
    }

    func checkMicrophonePermission(completion: (() -> Void)?) {
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            if !allowed {
                completion?()
                self.microphonePermssonCallBack?(false)
            } else {
                completion?()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if auth.isFirstLaunch {
            checkMicrophonePermission(completion: nil)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppDelegate.persistentName)
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

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
    var microphone = Microphone()
    var window: UIWindow?
    static var instance = UIApplication.shared.delegate as! AppDelegate
    
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
            _ = AudioManager()
            controller.modelController = ModelController()
            let navVC = NavigationController.init(rootViewController: controller)
            self.window?.rootViewController = navVC
            microphone.checkMicrophonePermission(completion: nil)
        } else {
            let authStoryboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            let controller = authStoryboard.instantiateViewController(withIdentifier: "PermissionViewController") as! PermissionViewController
            controller.microphone = microphone
            let navVC = NavigationController.init(rootViewController: controller)
            self.window?.rootViewController = navVC
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if auth.isFirstLaunch {
            microphone.checkMicrophonePermission(completion: nil)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        StorageDataSource.shared.saveContext()
    }

}

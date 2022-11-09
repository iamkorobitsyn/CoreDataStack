//
//  AppDelegate.swift
//  CoreDataStack
//
//  Created by Александр Коробицын on 10.11.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nv = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = nv
        window?.makeKeyAndVisible()

        return true
    }
}

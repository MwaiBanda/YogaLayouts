//
//  AppDelegate.swift
//  YogaLayouts
//
//  Created by Mwai Banda on 9/1/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = GodViewController()
        window?.makeKeyAndVisible()
        return true
    }

}


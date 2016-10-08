//
//  AppDelegate.swift
//  Menu Checker
//
//  Created by Luca Hagel on 7/11/16.
//  Copyright © 2016 Luca Hagel. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Answers.self, Crashlytics.self])
        let defaults = UserDefaults.standard
        if defaults.array(forKey: "UserPrefs") == nil {
            defaults.set([String](), forKey: "UserPrefs")
        }
        
        return true
    }
}


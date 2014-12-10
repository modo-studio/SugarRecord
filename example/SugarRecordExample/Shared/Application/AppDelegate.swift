//
//  AppDelegate.swift
//  SugarRecordExample
//
//  Created by Robert Dougan on 10/12/14.
//  Copyright (c) 2014 Robert Dougan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    // The following 3 methods are VERY important. If not added, your data will not be stored when your app is closed.
    
    func applicationWillResignActive(application: UIApplication) {
        SugarRecord.applicationWillResignActive()
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        SugarRecord.applicationWillEnterForeground()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        SugarRecord.applicationWillTerminate()
    }

}


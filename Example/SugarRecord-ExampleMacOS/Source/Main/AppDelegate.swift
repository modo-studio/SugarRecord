//
//  AppDelegate.swift
//  SugarRecord-ExampleMacOS
//
//  Created by Jorge Martín Espinosa on 10/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Cocoa
import SugarRecord

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }

}

var db: CoreDataDefaultStorage = {
    let store = CoreDataStore.named("cd_basic")
    let bundle = Bundle.main
    let model = CoreDataObjectModel.merged([bundle])
    let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
    return defaultStorage
}()

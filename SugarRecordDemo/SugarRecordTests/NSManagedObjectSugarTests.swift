//
//  NSManagedObjectSugarTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 03/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Quick
import SugarRecord
import Nimble
import CoreData

class NSManagedObjectSugarTests: QuickSpec {
    override func spec() {
        beforeSuite {
            // Creating database stack
            SugarRecord.setupCoreDataStack(automigrating:true, databaseName: "testDatabase")
        }
        
        afterSuite {
            // Removing database
            let success: Bool = SugarRecord.removeDatabaseNamed("testDatabase")
        }
        
        
        
//        
//        describe("when initializing core", { () -> () in
//            it ("should initialize a default persistant store coordinator") {
//                expect(NSPersistentStoreCoordinator.defaultPersistentStoreCoordinator()).toNot(beNil())
//            }
//        });
//        
//        describe("deleting the database", { () -> () in
//            it ("should delete the database locally if it exists") {
//                let databaseName: String = "testDatabase"
//                SugarRecord.removeDatabaseNamed(databaseName)
//                let url: NSURL = NSPersistentStore.storeUrl(forDatabaseName: databaseName)
//                let fileManager: NSFileManager = NSFileManager.defaultManager()
//                expect(fileManager.fileExistsAtPath(url.absoluteString!)).to(equal(false))
//                SugarRecord.setupCoreDataStack(automigrating:true, databaseName: "testDatabase")
//            }
//        })
//        
//        describe("cleaning up", { () -> () in
//            // TODO - Ensure methods calls here (expectations)
//        })
//        
//        describe("cleaning up the stack", { () -> () in
//            // TODO - Ensure methods calls here too
//        })
    }
}
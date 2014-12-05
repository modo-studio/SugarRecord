//
//  SugarRecordInformationTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 03/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Quick
import SugarRecord
import Nimble
import CoreData

class SugarRecordInformationTests: QuickSpec {
    override func spec() {
        beforeSuite {
            // Creating database stack
            SugarRecord.setupCoreDataStack(automigrating:true, databaseName: "testDatabase")
        }
        
        afterSuite {
            // Removing database
            let success: Bool = SugarRecord.removeDatabaseNamed("testDatabase")
        }
        
        context("getting information about the library") {
            it ("should return the version from the constant") {
                expect(SugarRecord.currentVersion()).to(equal(srSugarRecordVersion))
            }
        }
        context("returning the default database name") {
            it ("should use the mainBundle name if it exists") {
                let bundleName: AnyObject? = NSBundle.mainBundle().infoDictionary[kCFBundleNameKey]
                if let name = bundleName as? String {
                    expect(SugarRecord.defaultDatabaseName()).to(equal(name.stringByAppendingPathExtension("sqlite")))
                }
            }
        }
    }
}
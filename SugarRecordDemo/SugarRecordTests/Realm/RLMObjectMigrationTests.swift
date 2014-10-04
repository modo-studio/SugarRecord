//
//  RLMObjectMigrationTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 04/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import Realm

class RLMObjectMigrationTests: XCTestCase {
    
    override func setUp()
    {
        super.setUp()
        SugarRecord.addStack(DefaultREALMStack(stackName: "RealmTest", stackDescription: "Realm stack for tests"))
    }
    
    override func tearDown() {
        super.tearDown()
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
    }
    
    func testIfExecutesMigrationClosurePassedTheRealmMigrationObject() {
        var realmObject: RealmObject = RealmObject.create() as RealmObject
        realmObject.name = "Realmy"
        realmObject.age = 22
        realmObject.email = "test@mail.com"
        realmObject.city = "TestCity"
        realmObject.birthday = NSDate()
        let saved: Bool = realmObject.save()
        let expectation = expectationWithDescription("Migration closure should be called")
        let realmObjectMigration: RLMObjectMigration<RealmObject> = RLMObjectMigration<RealmObject> (toSchema: 1) { (oldObject, newObject) -> () in
            expectation.fulfill()
        }
        RLMRealm.migrateDefaultRealmWithBlock({ (realmMigration: RLMMigration!, oldSchema: UInt) -> UInt in
            realmObjectMigration.migrate(realmMigration)
            return UInt(0)
        })
        waitForExpectationsWithTimeout(0.1, handler: { error in })
        realmObject.beginWriting().delete().endWriting()
    }
}
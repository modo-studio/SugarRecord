//
//  SugarRecordRLMContextTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 11/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import CoreData
import XCTest
import Realm

class SugarRecordRLMContextTests: XCTestCase
{
    class MockRLMRealm: RLMRealm
    {
        var beginWriteTransactionCalled: Bool = false
        var commitWriteTransactionCalled: Bool = false
        var objectAdded: Bool = false
        
        override func commitWriteTransaction() {
            self.commitWriteTransactionCalled = true
        }
        
        override func beginWriteTransaction() {
            self.beginWriteTransactionCalled = true
        }
        
        override func addObject(object: RLMObject!) {
            self.objectAdded = true
        }
    }
    
    func testThatBegingWrittingCallsBeginWriteTransationInRealmContext()
    {
        let context: MockRLMRealm = MockRLMRealm()
        let srContext: SugarRecordRLMContext = SugarRecordRLMContext(realmContext: context)
        srContext.beginWritting()
        XCTAssertTrue(context.beginWriteTransactionCalled, "BeginWritting should notify the REALM Context")
    }
    
    func testThatEndWrittingCallsCommitWriteTransationInRealmContext()
    {
        let context: MockRLMRealm = MockRLMRealm()
        let srContext: SugarRecordRLMContext = SugarRecordRLMContext(realmContext: context)
        srContext.endWritting()
        XCTAssertTrue(context.commitWriteTransactionCalled, "EndWritting should notify the REALM Context")
    }
    
    func testObjectCreation()
    {
        let context: MockRLMRealm = MockRLMRealm()
        let srContext: SugarRecordRLMContext = SugarRecordRLMContext(realmContext: context)
        srContext.endWritting()
        let realmObject: RealmObject = srContext.createObject(RealmObject.self) as RealmObject
        XCTAssertNil(realmObject.realm, "Created realm object shouldn't have a realm object")
    }
    
    func testInsertObjectShouldInsertTheObjectInRealm()
    {
        let context: MockRLMRealm = MockRLMRealm()
        let srContext: SugarRecordRLMContext = SugarRecordRLMContext(realmContext: context)
        srContext.endWritting()
        let realmObject: RealmObject = srContext.createObject(RealmObject.self) as RealmObject
        srContext.insertObject(realmObject)
        XCTAssertTrue(context.objectAdded, "Object should be added to Realm")
    }
    
    func testDeleteObjectsShouldCallDeleteObjectForEachObject()
    {
        class MockRLMContext: SugarRecordRLMContext
        {
            var deleteObjectCalled: Bool = false
            override func deleteObject(object: AnyObject) -> SugarRecordContext {
                deleteObjectCalled = true
                return self
            }
        }
        
        let context: MockRLMContext = MockRLMContext(realmContext: RLMRealm())
        let object: RealmObject = RealmObject()
        context.deleteObjects([object])
        XCTAssertTrue(context.deleteObjectCalled, "Delete object should be called when deleting multiple objects")
    }
}
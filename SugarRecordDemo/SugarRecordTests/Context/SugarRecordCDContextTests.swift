//
//  SugarRecordCDContextTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 11/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Quick
import SugarRecord
import Nimble
import CoreData

class SugarRecordCDContextTests: QuickSpec {
    override func spec() {
        // Test Context
        class TestManagedObjectContext: NSManagedObjectContext {
            var saved: Bool?
            public override func save(error: NSErrorPointer) -> Bool {
                
            }
        }
        
        var srContext: SugarRecordCDContext
        var testContext: TestManagedObjectContext
        
        beforeSuite
        {
            testContext = TestManagedObjectContext()
            srContext = SugarRecordCDContext(context: testContext)
        }
        afterSuite {}
    
        
        describe("when beginning writting", { () -> () in
            
        })
        
        describe("when ending writting", { () -> () in
            
        })
        
        describe("when inserting object", { () -> () in
            
        })
        
        describe("when removing object", { () -> () in
            
        })
    }
}

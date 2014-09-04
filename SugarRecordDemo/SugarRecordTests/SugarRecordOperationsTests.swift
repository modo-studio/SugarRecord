//
//  SugarRecordOperationsTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 03/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Quick
import SugarRecord
import Nimble
import CoreData

class SugarRecordOperationsTests: QuickSpec {
    
    let dbName = "SavingDataBase"
    
    override func spec() {
        beforeSuite {
            // Creating database stack
            SugarRecord.setupCoreDataStack(automigrating:true, databaseName: self.dbName)
        }
        
        afterSuite {
            // Removing database
            let success: Bool = SugarRecord.removeDatabaseNamed(self.dbName)
        }
        
        context("Create an entity Person") {
            
            it ("should save successfully") {
                var saved = false
                SugarRecord.save(inBackground: true, savingBlock: { (context) -> () in
                    let fran: Person = Person.create(inContext: context) as Person
                    fran.name = "Fran"
                    fran.age = "27"
                    }) { (success, error) -> () in
                        expect(success).to(equal(true))
                        println(error)
                        saved = true
                }
                
                expect(saved).toEventually(equal(true))
            }
            
            it ("should save on a background thread and completion clousure called in the mainThread") {
                var saved = false
                SugarRecord.save(inBackground: true, savingBlock: { (context) -> () in
                    expect(NSThread.currentThread()).toNot(equal(NSThread.mainThread()));
                    }) { (success, error) -> () in
                        expect(NSThread.currentThread()).to(equal(NSThread.mainThread()));
                        saved = true
                }
                
                expect(saved).toEventually(equal(true))
            }
        }
        
    }
}
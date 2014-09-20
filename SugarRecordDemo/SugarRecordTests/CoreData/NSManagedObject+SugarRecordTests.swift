//
//  NSManagedObject+SugarRecordTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreData

class NSManagedObjectSugarRecordTests: QuickSpec {
    override func spec() {
        beforeSuite {}
        afterSuite {}
        
        context("when filtering", { () -> () in
            it("should return the objectClass set in the finder", { () -> () in
                // TODO - Pending to check how to compare if two classes are the same
            })
            
            it("should set the predicate to the finder returned", { () -> () in
                var predicate: NSPredicate = NSPredicate()
                var finder: SugarRecordFinder = NSManagedObject.by(predicate)
                expect(finder.predicate!).to(beIdenticalTo(predicate))
                finder = NSManagedObject.by("name == Test")
                expect(finder.predicate!.predicateFormat).to(equal("name == Test"))
                finder = NSManagedObject.by("name", equalTo: "Test")
                expect(finder.predicate!.predicateFormat).to(equal("name == Test"))
            })
        })
        
        context("when sorting", { () -> () in
            it("should update the sort descriptor", { () -> () in
                var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                var finder: SugarRecordFinder = NSManagedObject.sorted(by: sortDescriptor)
                expect(finder.sortDescriptors.last!).to(beIdenticalTo(sortDescriptor))
                finder = NSManagedObject.sorted(by: "name", ascending: true)
                expect(finder.sortDescriptors.last!.key!).to(equal("name"))
                expect(finder.sortDescriptors.last!.ascending).to(beTruthy())
                finder = NSManagedObject.sorted(by: [sortDescriptor])
                expect(finder.sortDescriptors).to(equal([sortDescriptor]))
            })
        })
        
        context("when all", { () -> () in
            it("should return the finder with the all set", { () -> () in
                var finder: SugarRecordFinder = NSManagedObject.all()
                var isAll: Bool?
                switch finder.elements {
                case .all:
                    isAll = true
                default:
                    isAll = false
                }
                expect(isAll!).to(beTruthy())
            })
        })
    }
}

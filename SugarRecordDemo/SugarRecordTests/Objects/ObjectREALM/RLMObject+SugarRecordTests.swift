//
//  RLMObject+SugarRecordTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Quick
import SugarRecord
import Nimble
import CoreData

class RLMObjectSugarRecordTests: QuickSpec {
    override func spec() {
        beforeSuite {}
        afterSuite {}
        
        context("when filtering", { () -> () in
            it("should return the objectClass set in the finder", { () -> () in
                // TODO - Pending to check how to compare if two classes are the same
            })
            
            it("should set the predicate to the finder returned", { () -> () in
                var predicate: NSPredicate = NSPredicate()
                var finder: SugarRecordFinder = RLMObject.by(predicate)
                expect(finder.predicate!).to(beIdenticalTo(predicate))
                finder = RLMObject.by("name == Test")
                expect(finder.predicate!.predicateFormat).to(equal("name == Test"))
                finder = RLMObject.by("name", equalTo: "Test")
                expect(finder.predicate!.predicateFormat).to(equal("name == Test"))
            })
        })
        
        context("when sorting", { () -> () in
            it("should update the sort descriptor", { () -> () in
                var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                var finder: SugarRecordFinder = RLMObject.sorted(by: sortDescriptor)
                expect(finder.sortDescriptors.last!).to(beIdenticalTo(sortDescriptor))
                finder = RLMObject.sorted(by: "name", ascending: true)
                expect(finder.sortDescriptors.last!.key!).to(equal("name"))
                expect(finder.sortDescriptors.last!.ascending).to(beTruthy())
                finder = RLMObject.sorted(by: [sortDescriptor])
                expect(finder.sortDescriptors).to(equal([sortDescriptor]))
            })
        })
        
        context("when all", { () -> () in
            it("should return the finder with the all set", { () -> () in
                var finder: SugarRecordFinder = RLMObject.all()
                var isAll: Bool?
                switch finder.elements! {
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

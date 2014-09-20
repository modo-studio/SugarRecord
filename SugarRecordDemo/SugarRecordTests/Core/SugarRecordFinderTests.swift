//
//  SugarRecordFinderTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendia on 07/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreData

class SugarRecordFinderTests: QuickSpec {
    override func spec() {
        beforeSuite {}
        afterSuite {}

        describe("sortDescriptors", { () -> () in
            var sugarRecordFinder: SugarRecordFinder!
            beforeEach({ () -> () in
                sugarRecordFinder = SugarRecordFinder()
            })
            
            it("should add the sortDescriptor to the finder sortDescriptors property", { () -> () in
                let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "test", ascending: true)
                sugarRecordFinder.addSortDescriptor(sortDescriptor)
                expect(sugarRecordFinder.sortDescriptorsCount()).to(equal(1))
            })
            
            it("should append the sort descriptor passing the key and the ascending value", { () -> () in
                let sortDescriptor: SugarRecordFinder = sugarRecordFinder.addSortDescriptor(byKey: "name", ascending: true)
                expect(sugarRecordFinder.sortDescriptors.last!.ascending).to(equal(true))
                expect(sugarRecordFinder.sortDescriptors.last!.key).to(equal("name"))
            })
        });
        
        describe("predicates", { () -> () in
            var sugarRecordFinder: SugarRecordFinder!
            beforeEach({ () -> () in
                sugarRecordFinder = SugarRecordFinder()
            })
            
            it("should add the predicate to the finder predicates", { () -> () in
                let predicate: NSPredicate = NSPredicate()
                sugarRecordFinder.setPredicate(predicate)
                expect(sugarRecordFinder.predicate).to(beIdenticalTo(predicate))
            })
            
            it("should translate the predicateString into a NSpredicate", { () -> () in
                let predicateString: String = "name == NULL"
                sugarRecordFinder.setPredicate(predicateString)
                let predicate: NSPredicate = sugarRecordFinder.predicate!
                expect(predicate.predicateFormat).to(equal("name == nil"))
            })
        });
        
        describe("elements", { () -> () in
            var sugarRecordFinder: SugarRecordFinder!
            
            beforeEach({ () -> () in
                sugarRecordFinder = SugarRecordFinder()
            })
            
            it("should update the elements attribute when ALL", { () -> () in
                sugarRecordFinder = sugarRecordFinder.all()
                var isAll: Bool?
                switch sugarRecordFinder.elements {
                case .all:
                    isAll = true
                default:
                    isAll = false
                }
                expect(isAll).to(equal(true))
            });
            
            it("should change the elements attribute when FIRST", { () -> () in
                sugarRecordFinder = sugarRecordFinder.first()
                var isFirst: Bool?
                switch sugarRecordFinder.elements {
                case .first:
                    isFirst = true
                default:
                    isFirst = false
                }
                expect(isFirst).to(equal(true))
            })
            
            it("should change the elements attribute when LAST", { () -> () in
                sugarRecordFinder = sugarRecordFinder.last()
                var isLast: Bool?
                switch sugarRecordFinder.elements {
                case .last:
                    isLast = true
                default:
                    isLast = false
                }
                expect(isLast).to(equal(true))
            })
            
            it("should change the elements attribute when LASTS", { () -> () in
                sugarRecordFinder = sugarRecordFinder.lasts(20)
                var isLasts: Bool?
                switch sugarRecordFinder.elements {
                case .lasts(let count):
                    isLasts = count == 20
                default:
                    isLasts = false
                }
                expect(isLasts).to(equal(true))
            })
            
            it("should change the elements attribute when FIRSTS", { () -> () in
                sugarRecordFinder = sugarRecordFinder.firsts(20)
                var isFirsts: Bool?
                switch sugarRecordFinder.elements {
                case .firsts(let count):
                    isFirsts = count == 20
                default:
                    isFirsts = false
                }
                expect(isFirsts).to(equal(true))
            })
        })
    }
}

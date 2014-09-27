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
        beforeSuite
            {
                let bundle: NSBundle = NSBundle(forClass: RealmObjectTests.classForCoder())
                let modelPath: NSString = bundle.pathForResource("SugarRecord", ofType: "momd")!
                let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath))
                let stack: DefaultCDStack = DefaultCDStack(databaseName: "TestDB.sqlite", model: model, automigrating: true)
                SugarRecord.addStack(stack)
        }
        afterSuite
            {
                SugarRecord.cleanup()
                SugarRecord.removeDatabase()
        }
        context("object properties should be right", { () -> () in
            it("should return a SugarRecordCD context with the managedObjectContext of the object", { () -> () in
                let object: CoreDataObject = CoreDataObject.create() as CoreDataObject
                let context: SugarRecordCDContext = object.context() as SugarRecordCDContext
                expect(context.contextCD).to(beIdenticalTo(object.managedObjectContext))
            })
            
            it("should return the entity name without the namespace", { () -> () in
                expect(CoreDataObject.entityName()).to(equal("CoreDataObject"))
            })
            
            it("should returl the proper stack type", {() -> () in
                let sameClass: Bool = CoreDataObject.stackType() == SugarRecordStackType.SugarRecordStackTypeCoreData
                expect(sameClass).to(equal(true))
            })
        })
        context("when filtering", { () -> () in
            it("should set the predicate to the finder returned", { () -> () in
                var predicate: NSPredicate = NSPredicate()
                var finder: SugarRecordFinder = NSManagedObject.by(predicate)
                expect(finder.predicate!).to(beIdenticalTo(predicate))
                finder = NSManagedObject.by("name == Test")
                expect(finder.predicate!.predicateFormat).to(equal("name == Test"))
                finder = NSManagedObject.by("name", equalTo: "Test")
                expect(finder.predicate!.predicateFormat).to(equal("name == Test"))
            })
            
            it("should set the objectClass and the stackType to the finder", { () -> () in
                var predicate: NSPredicate = NSPredicate()
                var finder: SugarRecordFinder = CoreDataObject.by(predicate)
                var sameClass = finder.objectClass? is CoreDataObject.Type
                expect(sameClass).to(equal(true))
                expect(finder.stackType == SugarRecordStackType.SugarRecordStackTypeCoreData).to(equal(true))
                finder = NSManagedObject.by("name == Test")
                expect(sameClass).to(equal(true))
                expect(finder.stackType == SugarRecordStackType.SugarRecordStackTypeCoreData).to(equal(true))
                finder = NSManagedObject.by("name", equalTo: "Test")
                expect(sameClass).to(equal(true))
                expect(finder.stackType == SugarRecordStackType.SugarRecordStackTypeCoreData).to(equal(true))
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
            it("should set the objectClass and the stackType to the finder", { () -> () in
                var sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                var finder: SugarRecordFinder = NSManagedObject.sorted(by: sortDescriptor)
                var sameClass = finder.objectClass? is CoreDataObject.Type
                expect(sameClass).to(equal(true))
                expect(finder.stackType == SugarRecordStackType.SugarRecordStackTypeCoreData).to(equal(true))
                finder = NSManagedObject.sorted(by: "name", ascending: true)
                expect(sameClass).to(equal(true))
                expect(finder.stackType == SugarRecordStackType.SugarRecordStackTypeCoreData).to(equal(true))
                finder = NSManagedObject.sorted(by: [sortDescriptor])
                expect(sameClass).to(equal(true))
                expect(finder.stackType == SugarRecordStackType.SugarRecordStackTypeCoreData).to(equal(true))
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

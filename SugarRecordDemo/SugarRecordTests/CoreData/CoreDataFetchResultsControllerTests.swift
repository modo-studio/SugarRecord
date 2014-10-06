//
//  CoreDataFetchResultsControllerTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 06/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import XCTest

class CoreDataFetchResultsControllerTests: XCTestCase
{
    var finder: SugarRecordFinder?
    
    override func setUp()
    {
        super.setUp()
        let bundle: NSBundle = NSBundle(forClass: CoreDataObjectTests.classForCoder())
        let modelPath: NSString = bundle.pathForResource("SugarRecord", ofType: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOfURL: NSURL(fileURLWithPath: modelPath))
        let stack: DefaultCDStack = DefaultCDStack(databaseName: "TestDB.sqlite", model: model, automigrating: true)
        SugarRecord.addStack(stack)
        
        finder = SugarRecordFinder()
        finder!.objectClass = CoreDataObject.self
        finder!.addSortDescriptor(byKey: "name", ascending: true)
    }
    
    override func tearDown() {
        SugarRecord.cleanup()
        SugarRecord.removeDatabase()
        super.tearDown()
    }
    
    func testIfFetchedResultsControllerIsCalledWithNoCache()
    {
        let frc: NSFetchedResultsController = finder!.fetchedResultsController("name")
        XCTAssertNil(frc.cacheName, "Cahce name should be nil")
    }
    
    func testIfFetchedResultsControllerHasTheProperCache()
    {
        let frc: NSFetchedResultsController = finder!.fetchedResultsController("name", cacheName: "cachename")
        XCTAssertEqual(frc.cacheName!, "cachename", "The cache name should be: cachename")
    }
}
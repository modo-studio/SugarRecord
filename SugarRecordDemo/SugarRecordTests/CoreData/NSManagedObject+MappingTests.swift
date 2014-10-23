//
//  NSManagedObject+Mapping.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 23/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import XCTest
import CoreData

// Useful: Generate random data for testing http://www.mockaroo.com/

class NSManagedObjectMappingTests: XCTestCase
{
    func testIfDefaultMapperHasInferMappingEnabled()
    {
        let mapper: SugarRecordMapper = NSManagedObject.defaultMapper()
        XCTAssertTrue(mapper.inferMappingAttributes, "The infer mapping should be true")
    }
    
}
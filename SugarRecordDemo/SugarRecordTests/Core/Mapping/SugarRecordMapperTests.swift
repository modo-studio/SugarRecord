//
//  SugarRecordMapperTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 19/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import XCTest

class SugarRecordMapperTests: XCTestCase
{
    var mapper: SugarRecordMapper?
    
    override func setUp() {
        mapper = SugarRecordMapper()
    }
    
    func testIfAddAttributes()
    {
        mapper!.addAttribute(SugarRecordMappingAttribute.SimpleAttribute(localKey: "localtest", remoteKey: "remotetest"))
        XCTAssertEqual(mapper!.attributes.count, 1, "The number of attributes should be equal to 1")
    }
    
    func testIfRepeatedAttributedIsNotAddedAgain()
    {
        mapper!.addAttribute(SugarRecordMappingAttribute.SimpleAttribute(localKey: "localtest", remoteKey: "remotetest"))
        let result: Bool = mapper!.addAttribute(SugarRecordMappingAttribute.SimpleAttribute(localKey: "localtest", remoteKey: "remotetest"))
        XCTAssertFalse(result, "The same attribute shouldn't be added again")
    }
}
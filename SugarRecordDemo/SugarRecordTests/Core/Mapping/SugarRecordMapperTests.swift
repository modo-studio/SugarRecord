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
    let attributeNotFound: (SugarRecordMappingAttribute) -> (SugarRecordMappingAttribute) = { (notFoundAttribute) -> (SugarRecordMappingAttribute) in
        return notFoundAttribute
    }
    
    override func setUp() {
        mapper = SugarRecordMapper(inferMapping: true, attributeNotFound: attributeNotFound)
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
    
    func testIfInferAttributeIsTrue()
    {
        XCTAssertTrue(mapper!.inferMappingAttributes, "Infer mapping attributes should be true")
    }
    
    func testIfReturnsTheAttributeForAGivenRemoteKey()
    {
        mapper!.addAttribute(SugarRecordMappingAttribute.SimpleAttribute(localKey: "localtest", remoteKey: "remotetest"))
        let attribute: SugarRecordMappingAttribute = mapper!.attribute(forRemoteKey: "remotetest")!
        XCTAssertEqual(attribute, SugarRecordMappingAttribute.SimpleAttribute(localKey: "localtest", remoteKey: "remotetest"), "The returned attribute should be the one who match the remote key")
    }
    
    func testIfInfersTheAttributeIfMapperHasThisPropertySet()
    {
        mapper!.addAttribute(SugarRecordMappingAttribute.SimpleAttribute(localKey: "localtest", remoteKey: "remotetest"))
        let attribute: SugarRecordMappingAttribute = mapper!.attribute(forRemoteKey: "papapa")!
        XCTAssertEqual(attribute, SugarRecordMappingAttribute.SimpleAttribute(localKey: "papapa", remoteKey: "papapa"), "The returned attribute should be the one who match the remote key")
    }
    
    func testIfNotInfersTheATtributeIfThePropertyIsNo()
    {
        mapper = SugarRecordMapper(inferMapping: false, attributeNotFound: attributeNotFound)
        mapper!.addAttribute(SugarRecordMappingAttribute.SimpleAttribute(localKey: "localtest", remoteKey: "remotetest"))
        let attribute: SugarRecordMappingAttribute? = mapper!.attribute(forRemoteKey: "papapa")
        XCTAssertTrue(attribute == nil, "If inferring is disabled it should return nil if the attribute hasn't been found")
    }
}
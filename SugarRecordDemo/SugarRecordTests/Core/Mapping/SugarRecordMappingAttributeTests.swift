//
//  SugarRecordMappingAttributeTests.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 22/10/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import UIKit
import XCTest

class SugarRecordMappingAttributeTests: XCTestCase {
    
    func testIfTheRemoteKeyIsProperlyReturned()
    {
        XCTAssertEqual(SugarRecordMappingAttribute.SimpleAttribute(localKey: "local", remoteKey: "remote").remoteKey(), "remote", "The remote key returned should match the remote key of the enum")
        XCTAssertEqual(SugarRecordMappingAttribute.OneToOneRelationship(localKey: "local", remoteKey: "remote", isIDRelation: true).remoteKey(), "remote", "The remote key returned should match the remote key of the enum")
        XCTAssertEqual(SugarRecordMappingAttribute.OneToManyRelationship(localKey: "local", remoteKey: "remote", isIDRelation: true).remoteKey(), "remote", "The remote key returned should match the remote key of the enum")
        XCTAssertEqual(SugarRecordMappingAttribute.IdentifierAttribute(localKey: "local", remoteKey: "remote").remoteKey(), "remote", "The remote key returned should match the remote key of the enum")
    }
    
    func testIfTheLocalKeyIsProperlyReturned()
    {
        XCTAssertEqual(SugarRecordMappingAttribute.SimpleAttribute(localKey: "local", remoteKey: "remote").localKey(), "local", "The local key returned should match the local key of the enum")
        XCTAssertEqual(SugarRecordMappingAttribute.OneToOneRelationship(localKey: "local", remoteKey: "remote", isIDRelation: true).localKey(), "local", "The local key returned should match the local key of the enum")
        XCTAssertEqual(SugarRecordMappingAttribute.OneToManyRelationship(localKey: "local", remoteKey: "remote", isIDRelation: true).localKey(), "local", "The local key returned should match the local key of the enum")
        XCTAssertEqual(SugarRecordMappingAttribute.IdentifierAttribute(localKey: "local", remoteKey: "remote").localKey(), "local", "The local key returned should match the local key of the enum")
    }
}

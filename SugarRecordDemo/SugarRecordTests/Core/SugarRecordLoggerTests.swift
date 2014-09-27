//
//  SugarRecordLogger.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 27/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import UIKit
import XCTest

class SugarRecordLoggerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testFatalLogLevel()
    {
        SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelFatal
        XCTAssertTrue(SugarRecordLogger.logLevelFatal.log("fatal"), "It should show fatal logs")
        XCTAssertFalse(SugarRecordLogger.logLevelError.log("error"), "It shouldn't show error logs")
        XCTAssertFalse(SugarRecordLogger.logLevelWarn.log("warn"), "It shouldn't show warn logs")
        XCTAssertFalse(SugarRecordLogger.logLevelInfo.log("info"), "It shouldn't show info logs")
        XCTAssertFalse(SugarRecordLogger.logLevelVerbose.log("verbose"), "It shouldn't show verbose logs")
    }
    
    func testErrorLogLevel()
    {
        SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelError
        XCTAssertTrue(SugarRecordLogger.logLevelFatal.log("fatal"), "It should show fatal logs")
        XCTAssertTrue(SugarRecordLogger.logLevelError.log("error"), "It should show error logs")
        XCTAssertFalse(SugarRecordLogger.logLevelWarn.log("warn"), "It shouldn't show warn logs")
        XCTAssertFalse(SugarRecordLogger.logLevelInfo.log("info"), "It shouldn't show info logs")
        XCTAssertFalse(SugarRecordLogger.logLevelVerbose.log("verbose"), "It shouldn't show verbose logs")
    }

    func testWarnLogLevel()
    {
        SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelWarn
        XCTAssertTrue(SugarRecordLogger.logLevelFatal.log("fatal"), "It should show fatal logs")
        XCTAssertTrue(SugarRecordLogger.logLevelError.log("error"), "It should show error logs")
        XCTAssertTrue(SugarRecordLogger.logLevelWarn.log("warn"), "It should show warn logs")
        XCTAssertFalse(SugarRecordLogger.logLevelInfo.log("info"), "It shouldn't show info logs")
        XCTAssertFalse(SugarRecordLogger.logLevelVerbose.log("verbose"), "It shouldn't show verbose logs")
    }
    
    func testInfoLogLevel()
    {
        SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelInfo
        XCTAssertTrue(SugarRecordLogger.logLevelFatal.log("fatal"), "It should show fatal logs")
        XCTAssertTrue(SugarRecordLogger.logLevelError.log("error"), "It should show error logs")
        XCTAssertTrue(SugarRecordLogger.logLevelWarn.log("warn"), "It should show warn logs")
        XCTAssertTrue(SugarRecordLogger.logLevelInfo.log("info"), "It should show info logs")
        XCTAssertFalse(SugarRecordLogger.logLevelVerbose.log("verbose"), "It shouldn't show verbose logs")
    }
    
    func testVerboseLogLevel()
    {
        SugarRecordLogger.currentLevel = SugarRecordLogger.logLevelVerbose
        XCTAssertTrue(SugarRecordLogger.logLevelFatal.log("fatal"), "It should show fatal logs")
        XCTAssertTrue(SugarRecordLogger.logLevelError.log("error"), "It should show error logs")
        XCTAssertTrue(SugarRecordLogger.logLevelWarn.log("warn"), "It should show warn logs")
        XCTAssertTrue(SugarRecordLogger.logLevelInfo.log("info"), "It should show info logs")
        XCTAssertTrue(SugarRecordLogger.logLevelVerbose.log("verbose"), "It should show verbose logs")
    }

}

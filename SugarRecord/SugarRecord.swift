//
//  SugarRecord.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 03/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation
import CoreData

// MARK: Library Constants
public let srSugarRecordVersion: String = "v1.0 - Alpha"

// MARK: Options


// MARK: SugarRecord Initialization

/**
 *  Main Library class with some useful constants and methods
 */
public class SugarRecord {


    /**
     Clean up the stack and notifies it using key srKVOCleanedUpNotification
     */
    public class func cleanUp() {
        //TODO - What to do with the clean?
    }
    
    /**
     Returns the current version of SugarRecord

     :returns: String with the version value
     */
    public class func currentVersion() -> String {
        return srSugarRecordVersion
    }
    
}


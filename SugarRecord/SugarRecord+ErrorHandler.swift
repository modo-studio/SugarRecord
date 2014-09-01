//
//  SugarRecord+ErrorHandler.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation


// MARK - SugarRecord Error Handler

public extension SugarRecord {
    /**
     Handles an error arount the Library

     :param: error NError to be processed
     */
    class func handle(error: NSError?) {
        if error == nil  { return }
        SugarRecordLogger.logLevelFatal.log("Error caught: \(error)")
    }

    /**
     Handles an exception around the library

     :param: exception NSException to be processed
     */
    class func handle(exception: NSException?) {
        if exception == nil { return }
        SugarRecordLogger.logLevelError.log("Exception caught: \(exception)")
    }
    
}
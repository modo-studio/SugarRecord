//
//  SugarRecord+ErrorHandler.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

// MARK  Error codes
public enum SugarRecordErrorCodes: Int {
    case UserError, LibraryError, CoreDataError, REALMError
}

// MARK - SugarRecord Error Handler

public extension SugarRecord {
    /**
     Handles an error arount the Library

     :param: error NError to be processed
     */
    class func handle(error: NSError?) {
        if error == nil  { return }
        SugarRecordLogger.logLevelFatal.log("Error caught: \(error)")
        assert(true, "\(error?.localizedDescription)")
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
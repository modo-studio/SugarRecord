//
//  SugarRecordLogger.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 26/08/14.
//  Copyright (c) 2014 PPinera. All rights reserved.
//

import Foundation

/**
SugarRecordLogger is a logger to show messages coming from the library depending on the selected log level

- logLevelFatal:   Messages related with fatal events
- logLevelError:   Messages related with error events
- logLevelWarn:    Messages related with warm events
- logLevelInfo:    Messages related with information events
- logLevelVerbose: Messages related with verbose events
*/
enum SugarRecordLogger: Int {
    /// Current SugarRecord log level
    static var currentLevel: SugarRecordLogger = .logLevelInfo
    
    /// SugarRecord enum levels
    case logLevelFatal, logLevelError, logLevelWarn, logLevelInfo, logLevelVerbose
    
    /// Log the given message depending on the curret log level
    func log(let logMessage: String) -> () {
        switch self {
        case .logLevelFatal:
            print("SR-Fatal: \(logMessage) \n")
        case .logLevelError:
            if SugarRecordLogger.currentLevel == .logLevelFatal {
                return
            }
            print("SR-Error: \(logMessage) \n")
        case .logLevelWarn:
            if SugarRecordLogger.currentLevel == .logLevelFatal ||
                SugarRecordLogger.currentLevel == .logLevelError {
                    return
            }
            print("SR-Warm: \(logMessage) \n")
        case .logLevelInfo:
            if SugarRecordLogger.currentLevel == .logLevelFatal ||
                SugarRecordLogger.currentLevel == .logLevelError ||
                SugarRecordLogger.currentLevel == .logLevelWarn {
                    return
            }
            print("SR-Info: \(logMessage) \n")
        default:
            if SugarRecordLogger.currentLevel == .logLevelFatal ||
                SugarRecordLogger.currentLevel == .logLevelError ||
                SugarRecordLogger.currentLevel == .logLevelWarn ||
                SugarRecordLogger.currentLevel == .logLevelInfo{
                    return
            }
            print("SR-Verbose: \(logMessage) \n")
        }
    }
}
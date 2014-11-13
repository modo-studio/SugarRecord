public enum SugarRecordLogger: Int {
    /// Current SugarRecord log level
    static var currentLevel: SugarRecordLogger = .logLevelInfo
    
    /// SugarRecord enum levels
    case logLevelFatal, logLevelError, logLevelWarn, logLevelInfo, logLevelVerbose
}
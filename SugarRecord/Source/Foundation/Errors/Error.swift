import Foundation

public enum Error: ErrorType {
    case WriteError
    case InvalidType
    case FetchError(ErrorType)
    case Store(ErrorType)
    case InvalidOperation(String)
    case Unknown
}

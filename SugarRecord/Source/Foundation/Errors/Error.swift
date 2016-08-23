import Foundation

public enum Error: ErrorProtocol {
    case writeError
    case invalidType
    case fetchError(ErrorProtocol)
    case store(ErrorProtocol)
    case invalidOperation(String)
    case unknown
}

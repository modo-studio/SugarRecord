import Foundation

public indirect enum StorageError: Error {

    case writeError
    case invalidType
    case fetchError(Error)
    case store(Error)
    case invalidOperation(String)
    case unknown
    
}

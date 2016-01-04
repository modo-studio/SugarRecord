import Foundation

/**
 Returns the app document directory
 
 - returns: document directory
 */
func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths[0]
}

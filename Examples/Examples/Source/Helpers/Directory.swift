import Foundation

func databasePath(_ name: String) -> String {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    return documentsPath + "/\(name)"
}

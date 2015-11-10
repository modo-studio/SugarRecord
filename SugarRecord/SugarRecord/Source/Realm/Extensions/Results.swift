import Foundation
import RealmSwift

// MARK: - Results extension

extension Results {
    func toArray() -> [T] {
        var array = [T]()
        for var i = 0; i < count; i++ {
            array.append(self[i])
        }
        return array
    }
}


// MARK: - List extension

extension List {
    func toArray() -> [T] {
        var array = [T]()
        for var i = 0; i < count; i++ {
            array.append(self[i])
        }
        return array
    }
}
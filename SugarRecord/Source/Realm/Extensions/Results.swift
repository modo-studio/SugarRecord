import Foundation
import RealmSwift

extension Results {
    
    func toArray() -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            array.append(self[i])
        }
        return array
    }
    
}

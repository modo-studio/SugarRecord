import Foundation

extension Array {
    // TODO: - Test
    func filterAndMapIndex(include: Element -> Bool) -> [Int] {
        var indexes: [Int] = []
        self.enumerate().forEach { (element) in
            if include(element.element) {
                indexes.append(element.index)
            }
        }
        return indexes
    }
    
}
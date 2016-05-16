extension Array {
    
    func filterWithIndex(closure: (index: Int, element: Element) -> Bool) -> [Element] {
        var filtered: [Element] = []
        var index: Int = 0
        self.forEach { (element) in
            if closure(index: index, element: element) {
                filtered.append(element)
            }
            index = index + 1
        }
        return filtered
    }
    
    func mapWithIndex<T>(closure: (index: Int, element: Element) -> T) -> [T] {
        var mapped: [T] = []
        var index: Int = 0
        self.forEach { (element) in
            mapped.append(closure(index: index, element: element))
            index = index + 1
        }
        return mapped
    }
    
}

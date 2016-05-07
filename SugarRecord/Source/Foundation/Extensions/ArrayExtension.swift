extension Array {
    
    func filter(closure: (index: Int, element: Element) -> Bool) -> [Element] {
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
    
}
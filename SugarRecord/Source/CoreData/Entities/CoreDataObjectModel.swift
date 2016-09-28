import Foundation
import CoreData

public enum CoreDataObjectModel {
    
    case named(String, Bundle)
    case merged([Bundle]?)
    case url(URL)
    
    func model() -> NSManagedObjectModel? {
        switch self {
        case .merged(let bundles):
            return NSManagedObjectModel.mergedModel(from: bundles)
        case .named(let name, let bundle):
            return NSManagedObjectModel(contentsOf: bundle.url(forResource: name, withExtension: "momd")!)
        case .url(let url):
            return NSManagedObjectModel(contentsOf: url)
        }
        
    }
    
}

// MARK: - ObjectModel Extension (CustomStringConvertible)

extension CoreDataObjectModel: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
            case .named(let name): return "NSManagedObject model named: \(name) in the main NSBundle"
            case .merged(_): return "Merged NSManagedObjec models in the provided bundles"
            case .url(let url): return "NSManagedObject model in the URL: \(url)"
            }
        }
    }
}


// MARK: - ObjectModel Extension (Equatable)

extension CoreDataObjectModel: Equatable {}

public func == (lhs: CoreDataObjectModel, rhs: CoreDataObjectModel) -> Bool {
    return lhs.model() == rhs.model()
}

import Foundation
import CoreData

typealias Saver = (context: NSManagedObjectContext, save: () -> Void) -> Void

/**
 *  Protocol that identifies a persistence stack
 */
protocol Stack {
    
    var mainContext: Context { get }
}

import Foundation

typealias Saver = (context: Context, save: () -> Void) -> Void

/**
 *  Protocol that identifies a persistence storage
 */
protocol Storage {
    
    var mainContext: Context { get }
}

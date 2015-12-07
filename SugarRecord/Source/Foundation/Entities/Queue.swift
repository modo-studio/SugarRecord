import Foundation

/**
 Enum that represents a thread queue where operations get executed.
 
 - **Main:** Main thread queue.
 - **Background:** Background thread queue.
 - **Custom:** Custom Grand Central Dispatch Queue.
 */
public enum Queue {
    
    case Main
    case Background
    case Custom(dispatch_queue_t)
    
    func gcd() -> dispatch_queue_t {
        switch self {
        case .Main:
            return dispatch_get_main_queue()
        case .Background:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        case .Custom(let queue):
            return queue
        }
    }
}
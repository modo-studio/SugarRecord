import Foundation
import ReactiveCocoa

/**
 *  It represents an operation priority
 */
public enum Priority {
    
    // Main thread with the provided context
    case Main(Context)
    
    // Background thread with the provided context
    case Background(Context)
    
    // Same thread with the provided context
    case Same(Context)
    
    // In the given thread with the provided context
    case Other(Context, dispatch_queue_t)
    
    
    /**
     Runs the operation
     
     - parameter operation: operation to be executed
     
     - returns: signal producer that executes the action
     */
    func run<T, E>(operation: (Context) -> SignalProducer<T, E>) -> SignalProducer<T, E> {
        return SignalProducer<T, E> { (sink, disposable) in
            let context: Context = self.context()
            if let queue = self.queue() {
                dispatch_async(queue, { () -> Void in
                    operation(context).on(event: { (event) in
                        sink.action(event)
                    }).start()
                })
            }
            else {
                operation(context).on(event: { (event) in
                    sink.action(event)
                }).start()
            }
        }
    }
    
    // MARK: - Private
    
    private func queue() -> dispatch_queue_t? {
        var queue: dispatch_queue_t?
        switch self {
        case .Main(_):
            queue = dispatch_get_main_queue()
        case .Background(_):
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        case .Other(_, let _queue):
            queue = _queue
        default: break
        }
        return queue
    }
    
    private func context() -> Context {
        var context: Context?
        switch self {
        case .Main(let _context):
            context = _context
        case .Background(let _context):
            context = _context
        case .Other(let _context, _):
            context = _context
        case .Same(let _context):
            context = _context
        }
        return context!
    }
}
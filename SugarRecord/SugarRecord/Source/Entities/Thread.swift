import Foundation

public enum Thread {
    case Main(Context)
    case Background(Context)
    case Same(Context)
    case Other(Context, dispatch_queue_t)
}
import Dispatch

public protocol DispatchQueueExecutor {
    func executeAsync(work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueExecutor {
    public func executeAsync(work: @escaping @convention(block) () -> Void) {
        sync(execute: work)
    }
}

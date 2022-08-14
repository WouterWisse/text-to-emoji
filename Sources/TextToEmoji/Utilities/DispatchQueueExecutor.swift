import Dispatch

protocol DispatchQueueExecutor {
    func executeAsync(work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueExecutor {
    func executeSync(work: @escaping @convention(block) () -> Void) {
        sync(execute: work)
    }
}

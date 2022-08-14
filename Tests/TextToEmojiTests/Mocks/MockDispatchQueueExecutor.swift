import Foundation
@testable import TextToEmoji

final class MockDispatchQueueExecutor: DispatchQueueExecutor {

    var invokedExecuteAsync = false
    var invokedExecuteAsyncCount = 0
    var shouldInvokeExecuteAsyncWork = false

    func executeAsync(work: @escaping @convention(block) () -> Void) {
        invokedExecuteAsync = true
        invokedExecuteAsyncCount += 1
        if shouldInvokeExecuteAsyncWork {
            work()
        }
    }
}

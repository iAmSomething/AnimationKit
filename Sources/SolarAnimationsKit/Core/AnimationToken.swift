import Foundation

public final class AnimationToken: @unchecked Sendable {
    public let id: UUID
    private let lock = NSLock()
    private var _isCancelled: Bool = false
    private var completion: (@Sendable () -> Void)?
    private var isCompleted: Bool = false

    internal init(id: UUID = UUID()) {
        self.id = id
    }

    public func cancel() {
        lock.lock(); defer { lock.unlock() }
        _isCancelled = true
    }

    public var isCancelled: Bool {
        lock.lock(); defer { lock.unlock() }
        return _isCancelled
    }

    public func `then`(_ handler: @escaping @Sendable () -> Void) -> AnimationToken {
        lock.lock()
        let completed = isCompleted
        if !completed {
            completion = handler
        }
        lock.unlock()

        if completed {
            DispatchQueue.main.async { handler() }
        }
        return self
    }

    internal func complete() {
        lock.lock()
        guard !isCompleted else {
            lock.unlock()
            return
        }
        isCompleted = true
        let handler = completion
        completion = nil
        lock.unlock()

        if let handler = handler {
            DispatchQueue.main.async { handler() }
        }
    }
}

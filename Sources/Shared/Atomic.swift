//
//  File.swift
//  
//
//  Created by Michael Simons on 12/12/20.
//

import Foundation
public typealias Atomic = UnfairAtomic
public class AtomicType<T: Any, LockType: Lock> {
    
    private var lock = LockType()
    
    private var _value: T

    /// Returns the value boxed by `Atomic`
    public var value: T {
        return withValue { $0 }
    }
    
    /**
     Mutates in place the value boxed by `Atomic`
     
     Example:
     ```
     let array = Atomic([1,2,3])
     array.mutate { $0.append(4) }
     ```
     - Parameter with : block used to mutate the underlying value
     */
    @discardableResult
    public func mutate<Result>(_ body: (inout T) throws -> Result) rethrows -> Result {
        lock.lock()
        defer { lock.unlock() }
        return try body(&_value)
    }

    /// Like `mutate`, but passes the value as readonly, returning the result of the closure.
    ///
    /// Example:
    /// ```
    /// let array = Atomic([1, 2, 3])
    /// let sum = array.withValue { $0.reduce(0, +) } // 6
    /// ```
    public func withValue<Result>(_ body: (T) throws -> Result) rethrows -> Result {
        return try mutate {
            try body($0)
        }
    }

    /**
     
     Example:
     ```
     let array = Atomic([1,2,3]) // Atomic<Array<Int>>
     let optional = Atomic<Int?>(nil)
     let optionalString: Atomic<String?> = Atomic("Initial Value")
     ```
     
     - Parameter initial : initial value used within the Atmoic box
     */
    public init(_ initial: T) { _value = initial }
}

/**
 Atomic Wrapper using a `os_unfair_lock` to ensure atomicity
 */
final public class UnfairAtomic<T: Any>: AtomicType<T, UnfairLock> {}
public protocol Lock: AnyObject {
    func lock()
    func unlock()
    init()
}


// Due to Swift's memory model, we need to initialize our own backing memory for our primative locks
// http://www.russbishop.net/the-law
final public class UnfairLock: Lock {
    private var _lock: UnsafeMutablePointer<os_unfair_lock>
    
    public init() {
        _lock = UnsafeMutablePointer<os_unfair_lock>.allocate(capacity: 1)
        _lock.initialize(to: os_unfair_lock())
    }
    
    deinit {
        _lock.deallocate()
    }
    
    public func lock() {
        os_unfair_lock_lock(_lock)
    }
    
    public func unlock() {
        os_unfair_lock_unlock(_lock)
    }

}

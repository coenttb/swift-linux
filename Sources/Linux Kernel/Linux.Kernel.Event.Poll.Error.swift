// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-kernel open source project
//
// Copyright (c) 2024 Coen ten Thije Boonkkamp and the swift-kernel project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//
public import Kernel_Primitives

#if canImport(Glibc) || canImport(Musl)

    extension Kernel.Event.Poll {
        /// Errors from epoll operations.
        ///
        /// Low-level errors from epoll syscalls. Each case wraps the
        /// underlying `Kernel.Error.Code` for platform-specific details.
        /// Convert to `Kernel.Error` for semantic error handling.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// do {
        ///     let epfd = try Kernel.Event.Poll.create(flags: .cloexec)
        /// } catch let error as Kernel.Event.Poll.Error {
        ///     switch error {
        ///     case .create(let code):
        ///         print("epoll_create1 failed: \(code)")
        ///     case .interrupted:
        ///         // Retry the operation
        ///     default:
        ///         throw Kernel.Error(error)
        ///     }
        /// }
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/Event/Poll``
        /// - ``Kernel/Error``
        public enum Error: Swift.Error, Sendable, Equatable, Hashable {
            /// Failed to create an epoll instance.
            ///
            /// Returned by `epoll_create1`. Common causes: process has
            /// too many open file descriptors, system limit reached.
            case create(Kernel.Error.Code)

            /// Failed to modify the epoll interest list.
            ///
            /// Returned by `epoll_ctl`. Common causes: file descriptor
            /// not valid, already exists (for add), not found (for delete).
            case ctl(Kernel.Error.Code)

            /// Failed to wait for events.
            ///
            /// Returned by `epoll_wait`/`epoll_pwait`. Common causes:
            /// invalid epoll descriptor, invalid events buffer.
            case wait(Kernel.Error.Code)

            /// Operation was interrupted by a signal.
            ///
            /// The operation should typically be retried.
            case interrupted
        }
    }

    extension Kernel.Event.Poll.Error: CustomStringConvertible {
        public var description: String {
            switch self {
            case .create(let code):
                return "epoll_create1 failed (\(code))"
            case .ctl(let code):
                return "epoll_ctl failed (\(code))"
            case .wait(let code):
                return "epoll_wait failed (\(code))"
            case .interrupted:
                return "operation interrupted"
            }
        }
    }

#endif

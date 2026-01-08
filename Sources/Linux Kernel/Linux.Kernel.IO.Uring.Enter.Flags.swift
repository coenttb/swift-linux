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

#if canImport(Glibc) || canImport(Musl)
    public import Kernel_Primitives

    extension Kernel.IO.Uring.Enter {
        /// Flags controlling `io_uring_enter` behavior.
        ///
        /// These flags control what `io_uring_enter` does: submit operations,
        /// wait for completions, or both. They also control interaction with
        /// the kernel polling thread.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Submit and wait for at least one completion
        /// let submitted = try Kernel.IO.Uring.enter(
        ///     ring,
        ///     toSubmit: pendingCount,
        ///     minComplete: 1,
        ///     flags: [.getEvents]
        /// )
        ///
        /// // Just submit, don't wait
        /// let submitted = try Kernel.IO.Uring.enter(
        ///     ring,
        ///     toSubmit: pendingCount,
        ///     minComplete: 0,
        ///     flags: []
        /// )
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring``
        /// - ``Kernel/IO/Uring/Setup/Flags``
        public struct Flags: OptionSet, Sendable {
            public let rawValue: UInt32

            public init(rawValue: UInt32) {
                self.rawValue = rawValue
            }

            /// Waits for events from the completion queue.
            ///
            /// The call blocks until at least `minComplete` completions are
            /// available or the timeout expires.
            ///
            /// - Linux: `IORING_ENTER_GETEVENTS`
            public static let getEvents = Flags(rawValue: 1 << 0)

            /// Wakes up the SQ poll thread.
            ///
            /// Use when the kernel polling thread has gone to sleep and you've
            /// added new submissions. Only needed with `.sqPoll` setup flag.
            ///
            /// - Linux: `IORING_ENTER_SQ_WAKEUP`
            public static let sqWakeup = Flags(rawValue: 1 << 1)

            /// Waits for SQ ring space to become available.
            ///
            /// Blocks if the submission queue is full until space becomes
            /// available (completions are reaped).
            ///
            /// - Linux: `IORING_ENTER_SQ_WAIT`
            public static let sqWait = Flags(rawValue: 1 << 2)

            /// Uses extended argument format (kernel 5.11+).
            ///
            /// Enables passing additional parameters like sigmask or timeout
            /// via the `arg` parameter.
            ///
            /// - Linux: `IORING_ENTER_EXT_ARG`
            public static let extArg = Flags(rawValue: 1 << 3)

            /// Uses a registered ring fd (kernel 5.18+).
            ///
            /// The fd passed is an index into the registered ring fd array
            /// rather than a raw file descriptor.
            ///
            /// - Linux: `IORING_ENTER_REGISTERED_RING`
            public static let registeredRing = Flags(rawValue: 1 << 4)
        }
    }

#endif

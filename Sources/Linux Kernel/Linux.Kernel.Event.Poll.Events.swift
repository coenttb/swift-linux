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

    #if canImport(Glibc)
        internal import Glibc
        internal import CLinuxShim
    #elseif canImport(Musl)
        internal import Musl
    #endif

    extension Kernel.Event.Poll {
        /// Event flags for epoll specifying interests and returned conditions.
        ///
        /// Used both when registering interest (what to monitor) and when
        /// receiving events (what happened). Some flags are input-only (`.et`),
        /// some output-only (`.err`, `.hup`), and some both.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Register interest in read readiness, edge-triggered
        /// try Kernel.Event.Poll.control(
        ///     epfd,
        ///     operation: .add,
        ///     descriptor: fd,
        ///     events: [.in, .et]
        /// )
        ///
        /// // Check returned events
        /// for event in events {
        ///     if event.events.contains(.in) {
        ///         // Data available to read
        ///     }
        ///     if event.events.contains(.hup) {
        ///         // Peer disconnected
        ///     }
        /// }
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/Event/Poll``
        /// - ``Kernel/Event/Poll/Operation``
        public struct Events: Sendable, Equatable, Hashable {
            public let rawValue: UInt32

            public init(rawValue: UInt32) {
                self.rawValue = rawValue
            }
        }
    }

    // MARK: - Event Flags

    extension Kernel.Event.Poll.Events {
        /// File descriptor is available for read operations.
        ///
        /// Data can be read without blocking. For sockets, also indicates
        /// incoming connections (for listening sockets) or EOF.
        ///
        /// - Linux: `EPOLLIN`
        public static let `in` = Self(rawValue: EPOLLIN.rawValue)

        /// File descriptor is available for write operations.
        ///
        /// Data can be written without blocking. Buffer space is available.
        ///
        /// - Linux: `EPOLLOUT`
        public static let out = Self(rawValue: EPOLLOUT.rawValue)

        /// Stream socket peer closed connection or shut down writing.
        ///
        /// Useful for detecting half-close before `read()` returns 0.
        /// Must be explicitly requested; not always returned by default.
        ///
        /// - Linux: `EPOLLRDHUP`
        public static let rdhup = Self(rawValue: EPOLLRDHUP.rawValue)

        /// Urgent/priority data available for read.
        ///
        /// Out-of-band data on TCP sockets. Rarely used in practice.
        ///
        /// - Linux: `EPOLLPRI`
        public static let pri = Self(rawValue: EPOLLPRI.rawValue)

        /// Error condition on the file descriptor.
        ///
        /// Output only - always reported when it occurs, regardless of
        /// requested events. Check `getsockopt(SO_ERROR)` for details.
        ///
        /// - Linux: `EPOLLERR`
        public static let err = Self(rawValue: EPOLLERR.rawValue)

        /// Hang up on the file descriptor.
        ///
        /// Output only - connection closed by peer. Does not prevent
        /// reading remaining data from buffers.
        ///
        /// - Linux: `EPOLLHUP`
        public static let hup = Self(rawValue: EPOLLHUP.rawValue)

        /// Enables edge-triggered mode.
        ///
        /// Events only fire on state *changes*, not while the condition
        /// persists. You must fully drain reads/writes or the event won't
        /// re-trigger. More efficient but requires careful handling.
        ///
        /// - Linux: `EPOLLET`
        public static let et = Self(rawValue: EPOLLET.rawValue)

        /// Enables one-shot mode.
        ///
        /// After delivering one event, the descriptor is disabled (not removed).
        /// Re-arm with `EPOLL_CTL_MOD` to receive more events.
        ///
        /// - Linux: `EPOLLONESHOT`
        public static let oneshot = Self(rawValue: EPOLLONESHOT.rawValue)
    }

    // MARK: - Combining

    extension Kernel.Event.Poll.Events {
        /// Combines multiple event flags.
        public static func | (lhs: Self, rhs: Self) -> Self {
            Self(rawValue: lhs.rawValue | rhs.rawValue)
        }

        /// Checks if this contains another event flag.
        public func contains(_ other: Self) -> Bool {
            (rawValue & other.rawValue) == other.rawValue
        }
    }

#endif

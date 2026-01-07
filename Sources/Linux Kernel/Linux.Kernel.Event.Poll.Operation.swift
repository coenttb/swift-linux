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
        /// Operations for modifying an epoll interest list.
        ///
        /// Used with `epoll_ctl` to add, modify, or remove file descriptors
        /// from an epoll instance's interest list. Each operation type has
        /// different requirements and error conditions.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Add a socket to the epoll instance
        /// try Kernel.Event.Poll.control(
        ///     epfd,
        ///     operation: .add,
        ///     descriptor: socketFd,
        ///     events: [.in, .et]
        /// )
        ///
        /// // Later, modify the interest set
        /// try Kernel.Event.Poll.control(
        ///     epfd,
        ///     operation: .modify,
        ///     descriptor: socketFd,
        ///     events: [.in, .out, .et]
        /// )
        ///
        /// // Remove when done
        /// try Kernel.Event.Poll.control(
        ///     epfd,
        ///     operation: .delete,
        ///     descriptor: socketFd,
        ///     events: []
        /// )
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/Event/Poll``
        /// - ``Kernel/Event/Poll/Events``
        public struct Operation: RawRepresentable, Sendable, Equatable, Hashable {
            public let rawValue: Int32

            @inlinable
            public init(rawValue: Int32) {
                self.rawValue = rawValue
            }
        }
    }

    extension Kernel.Event.Poll.Operation {
        /// Adds a file descriptor to the epoll interest list.
        ///
        /// The descriptor must not already be in the interest list. If it is,
        /// the operation fails with `EEXIST`. To change events for an existing
        /// descriptor, use `.modify` instead.
        ///
        /// - Linux: `EPOLL_CTL_ADD`
        public static let add = Self(rawValue: EPOLL_CTL_ADD)

        /// Modifies the events for an existing file descriptor.
        ///
        /// The descriptor must already be in the interest list. If not,
        /// the operation fails with `ENOENT`. Use this to change which
        /// events you're interested in or to re-arm a one-shot descriptor.
        ///
        /// - Linux: `EPOLL_CTL_MOD`
        public static let modify = Self(rawValue: EPOLL_CTL_MOD)

        /// Removes a file descriptor from the epoll interest list.
        ///
        /// The descriptor must be in the interest list. After removal,
        /// the descriptor will no longer generate events. Note that closing
        /// a file descriptor automatically removes it from all epoll instances.
        ///
        /// - Linux: `EPOLL_CTL_DEL`
        public static let delete = Self(rawValue: EPOLL_CTL_DEL)
    }

#endif

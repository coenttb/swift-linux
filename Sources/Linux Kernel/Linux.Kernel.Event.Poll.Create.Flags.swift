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
    #elseif canImport(Musl)
        internal import Musl
    #endif

    #if canImport(CLinuxShim)
        internal import CLinuxShim
    #endif

    extension Kernel.Event.Poll.Create {
        /// Flags for creating an epoll instance.
        ///
        /// Used with `epoll_create1` to control the behavior of the
        /// newly created epoll file descriptor.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Create epoll with close-on-exec (recommended)
        /// let epfd = try Kernel.Event.Poll.create(flags: .cloexec)
        /// defer { try? Kernel.Close.close(epfd) }
        ///
        /// // Add descriptors and poll for events...
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/Event/Poll``
        /// - ``Kernel/Event/Poll/Operation``
        public struct Flags: OptionSet, Sendable, Hashable {
            public let rawValue: Int32

            public init(rawValue: Int32) {
                self.rawValue = rawValue
            }
        }
    }

    extension Kernel.Event.Poll.Create.Flags {
        /// No flags.
        public static let none = Self(rawValue: 0)

        /// Sets the close-on-exec flag on the epoll file descriptor.
        ///
        /// Prevents the epoll fd from leaking to child processes created
        /// with `exec()`. Recommended for most applications.
        ///
        /// - Linux: `EPOLL_CLOEXEC`
        public static let cloexec = Self(rawValue: Int32(EPOLL_CLOEXEC))
    }

#endif

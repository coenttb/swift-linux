// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-kernel open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-kernel project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//
public import Kernel_Primitives

#if canImport(Glibc) || canImport(Musl)

    extension Kernel.IOUring {
        /// Namespace for buffer-related types.
        ///
        /// Contains types for working with registered buffers and buffer
        /// groups (automatic buffer selection) in io_uring.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring/Buffer/Index``
        /// - ``Kernel/IOUring/Buffer/Group``
        /// - ``Kernel/IOUring/RegisterOpcode/registerBuffers``
        public enum Buffer {}
    }

    // MARK: - Buffer.Index

    extension Kernel.IOUring.Buffer {
        /// Index into a registered buffer array.
        ///
        /// Used with `IORING_OP_READ_FIXED` and `IORING_OP_WRITE_FIXED` to reference
        /// pre-registered buffers for zero-copy I/O.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// sqe.bufferIndex = Buffer.Index(0)  // Use first registered buffer
        /// ```
        public struct Index: RawRepresentable, Sendable, Equatable, Hashable {
            public let rawValue: UInt16

            /// Creates a buffer index from a raw value.
            @inlinable
            public init(rawValue: UInt16) {
                self.rawValue = rawValue
            }

            /// Creates a buffer index from a UInt16 value.
            @inlinable
            public init(_ value: UInt16) {
                self.rawValue = value
            }

            // MARK: - Common Values

            /// First buffer in the registered array.
            public static let first = Index(0)
        }
    }

    // MARK: - Buffer.Index + ExpressibleByIntegerLiteral

    extension Kernel.IOUring.Buffer.Index: ExpressibleByIntegerLiteral {
        @inlinable
        public init(integerLiteral value: UInt16) {
            self.rawValue = value
        }
    }

    // MARK: - Buffer.Index + CustomStringConvertible

    extension Kernel.IOUring.Buffer.Index: CustomStringConvertible {
        public var description: String {
            "\(rawValue)"
        }
    }

    // MARK: - Buffer.Group

    extension Kernel.IOUring.Buffer {
        /// Buffer group identifier for automatic buffer selection.
        ///
        /// Used with `IOSQE_BUFFER_SELECT` flag to let the kernel select a buffer
        /// from a pre-registered pool. This enables efficient buffer management
        /// for operations where the buffer size isn't known in advance.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Register a buffer group
        /// let group = Buffer.Group(1)
        ///
        /// // Use buffer selection in SQE
        /// sqe.flags |= IOSQE_BUFFER_SELECT
        /// sqe.bufferGroup = group
        /// ```
        public struct Group: RawRepresentable, Sendable, Equatable, Hashable {
            public let rawValue: UInt16

            /// Creates a buffer group from a raw value.
            @inlinable
            public init(rawValue: UInt16) {
                self.rawValue = rawValue
            }

            /// Creates a buffer group from a UInt16 value.
            @inlinable
            public init(_ value: UInt16) {
                self.rawValue = value
            }
        }
    }

    // MARK: - Buffer.Group + ExpressibleByIntegerLiteral

    extension Kernel.IOUring.Buffer.Group: ExpressibleByIntegerLiteral {
        @inlinable
        public init(integerLiteral value: UInt16) {
            self.rawValue = value
        }
    }

    // MARK: - Buffer.Group + CustomStringConvertible

    extension Kernel.IOUring.Buffer.Group: CustomStringConvertible {
        public var description: String {
            "\(rawValue)"
        }
    }

#endif

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

#if canImport(Glibc) || canImport(Musl)
    public import Kernel_Primitives

    extension Kernel.IO.Uring.Buffer {
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
            public init(rawValue: UInt16) {
                self.rawValue = rawValue
            }

            /// Creates a buffer index from a UInt16 value.
            public init(_ value: UInt16) {
                self.rawValue = value
            }

            // MARK: - Common Values

            /// First buffer in the registered array.
            public static let first = Index(0)
        }
    }

    // MARK: - Buffer.Index + ExpressibleByIntegerLiteral

    extension Kernel.IO.Uring.Buffer.Index: ExpressibleByIntegerLiteral {
        public init(integerLiteral value: UInt16) {
            self.rawValue = value
        }
    }

    // MARK: - Buffer.Index + CustomStringConvertible

    extension Kernel.IO.Uring.Buffer.Index: CustomStringConvertible {
        public var description: String {
            "\(rawValue)"
        }
    }

#endif

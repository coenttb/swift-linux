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

    extension Kernel.IO.Uring {
        /// I/O priority for io_uring operations.
        ///
        /// Controls the scheduling priority of I/O operations. Higher priority
        /// operations may be processed before lower priority ones.
        ///
        /// The value follows the `ioprio` format used by `ioprio_set(2)`:
        /// - Bits 13-15: Priority class (IOPRIO_CLASS_*)
        /// - Bits 0-12: Priority level within the class
        ///
        /// ## Usage
        ///
        /// ```swift
        /// sqe.priority = .normal
        /// sqe.priority = Priority(rawValue: IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 4))
        /// ```
        public struct Priority: RawRepresentable, Sendable, Equatable, Hashable, Comparable {
            public let rawValue: UInt16

            /// Creates a priority from a raw value.
            public init(rawValue: UInt16) {
                self.rawValue = rawValue
            }

            /// Creates a priority from a UInt16 value.
            public init(_ value: UInt16) {
                self.rawValue = value
            }

            // MARK: - Common Values

            /// Default priority (no priority set).
            public static let `default` = Priority(0)

            /// Normal priority (best-effort, middle level).
            public static let normal = Priority(0)

            // MARK: - Comparable

            public static func < (lhs: Priority, rhs: Priority) -> Bool {
                lhs.rawValue < rhs.rawValue
            }
        }
    }

    // MARK: - ExpressibleByIntegerLiteral

    extension Kernel.IO.Uring.Priority: ExpressibleByIntegerLiteral {
        public init(integerLiteral value: UInt16) {
            self.rawValue = value
        }
    }

    // MARK: - CustomStringConvertible

    extension Kernel.IO.Uring.Priority: CustomStringConvertible {
        public var description: String {
            "\(rawValue)"
        }
    }

#endif

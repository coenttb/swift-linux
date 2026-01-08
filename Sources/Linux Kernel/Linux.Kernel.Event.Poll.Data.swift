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
    public import Dimension

    extension Kernel.Event.Poll {
        /// Opaque data associated with an epoll event.
        ///
        /// Poll data is a 64-bit value that the kernel returns unchanged
        /// when the event fires. This is used to route events to their handlers.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Use as an identifier
        /// let data = Kernel.Event.Poll.Data(id)
        ///
        /// // Use with pointer-based context lookup
        /// let data = Kernel.Event.Poll.Data(pointer: contextPtr)
        /// ```
        public typealias Data = Tagged<Kernel.Event.Poll, UInt64>
    }

    // MARK: - Pointer Conversions

    extension Kernel.Event.Poll.Data {
        /// Creates poll data from a raw pointer.
        ///
        /// This is useful when you want to associate a context object
        /// with an event.
        ///
        /// - Parameter pointer: A pointer to associate with the event.
        public init(_ pointer: UnsafeRawPointer) {
            self.init(UInt64(UInt(bitPattern: pointer)))
        }

        /// Creates poll data from a typed pointer.
        ///
        /// - Parameter pointer: A pointer to associate with the event.
        public init<T>(pointer: UnsafePointer<T>) {
            self.init(UInt64(UInt(bitPattern: pointer)))
        }

        /// Creates poll data from a mutable typed pointer.
        ///
        /// - Parameter pointer: A mutable pointer to associate with the event.
        public init<T>(pointer: UnsafeMutablePointer<T>) {
            self.init(UInt64(UInt(bitPattern: pointer)))
        }
    }

    // MARK: - Common Values

    extension Kernel.Event.Poll.Data {
        /// Zero poll data.
        public static let zero: Self = 0
    }

#endif

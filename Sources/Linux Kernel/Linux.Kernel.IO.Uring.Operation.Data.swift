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
    public import Dimension
    public import Kernel_Primitives

    extension Kernel.IO.Uring.Operation {
        /// Opaque data associated with an io_uring operation.
        ///
        /// Operation data is a 64-bit value that the kernel returns unchanged
        /// in the corresponding completion queue entry. This is used to correlate
        /// completions with their submissions.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Use as an operation identifier
        /// let data = Kernel.IO.Uring.Operation.Data(operationId)
        ///
        /// // Use with pointer-based context lookup
        /// let data = Kernel.IO.Uring.Operation.Data(pointer: contextPtr)
        /// ```
        public typealias Data = Tagged<Kernel.IO.Uring.Operation, UInt64>
    }

    // MARK: - Pointer Conversions

    extension Kernel.IO.Uring.Operation.Data {
        /// Creates operation data from a raw pointer.
        ///
        /// This is useful when you want to associate a context object
        /// with an operation.
        ///
        /// - Parameter pointer: A pointer to associate with the operation.
        public init(_ pointer: UnsafeRawPointer) {
            self.init(UInt64(UInt(bitPattern: pointer)))
        }

        /// Creates operation data from a typed pointer.
        ///
        /// - Parameter pointer: A pointer to associate with the operation.
        public init<T>(pointer: UnsafePointer<T>) {
            self.init(UInt64(UInt(bitPattern: pointer)))
        }

        /// Creates operation data from a mutable typed pointer.
        ///
        /// - Parameter pointer: A mutable pointer to associate with the operation.
        public init<T>(pointer: UnsafeMutablePointer<T>) {
            self.init(UInt64(UInt(bitPattern: pointer)))
        }
    }

    // MARK: - Common Values

    extension Kernel.IO.Uring.Operation.Data {
        /// Zero operation data.
        public static let zero: Self = 0
    }

#endif

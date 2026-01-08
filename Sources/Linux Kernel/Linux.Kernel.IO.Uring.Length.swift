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

public import Binary
public import Kernel_Primitives

#if canImport(Glibc) || canImport(Musl)

    extension Kernel.IO.Uring {
        /// Buffer length for io_uring operations.
        ///
        /// A type-safe 32-bit length value using the Dimension pattern.
        /// Follows the same pattern as `Kernel.File.Size`.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // From an integer literal
        /// let length: Kernel.IO.Uring.Length = 4096
        ///
        /// // From a File.Size
        /// let length = Kernel.IO.Uring.Length(fileSize)
        ///
        /// // From a buffer pointer
        /// let length = Kernel.IO.Uring.Length(buffer)
        /// ```
        public typealias Length = Magnitude<Space>.Value<UInt32>
    }

    // MARK: - Convenience Initializers

    extension Kernel.IO.Uring.Length {
        /// Zero length.
        public static let zero: Self = 0

        /// Creates a length from an integer.
        ///
        /// Values larger than `UInt32.max` are clamped.
        ///
        /// - Parameter count: The length in bytes.
        public init(_ count: Int) {
            self.init(UInt32(clamping: count))
        }

        /// Creates a length from a buffer pointer.
        ///
        /// - Parameter buffer: The buffer whose count to use.
        public init(_ buffer: UnsafeRawBufferPointer) {
            self.init(UInt32(clamping: buffer.count))
        }

        /// Creates a length from a mutable buffer pointer.
        ///
        /// - Parameter buffer: The buffer whose count to use.
        public init(_ buffer: UnsafeMutableRawBufferPointer) {
            self.init(UInt32(clamping: buffer.count))
        }
    }

    // MARK: - File.Size Conversion

    extension Kernel.IO.Uring.Length {
        /// Creates a Length from a File.Size.
        ///
        /// Saturates at `UInt32.max` for sizes larger than 4GB.
        public init(_ size: Kernel.File.Size) {
            if size.rawValue > Int64(UInt32.max) {
                self.init(UInt32.max)
            } else if size.rawValue < 0 {
                self.init(UInt32(0))
            } else {
                self.init(UInt32(size.rawValue))
            }
        }
    }

#endif

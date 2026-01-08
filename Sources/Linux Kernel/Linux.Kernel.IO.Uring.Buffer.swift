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

    extension Kernel.IO.Uring {
        /// Namespace for buffer-related types and opcodes.
        ///
        /// Contains types for working with registered buffers and buffer
        /// groups (automatic buffer selection) in io_uring.
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring/Buffer/Index``
        /// - ``Kernel/IO/Uring/Buffer/Group``
        /// - ``Kernel/IO/Uring/Register/Opcode/registerBuffers``
        public enum Buffer {
            /// Provide buffers to kernel.
            public static let provide = Opcode(rawValue: 31)

            /// Remove provided buffers.
            public static let remove = Opcode(rawValue: 32)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to buffer management operation opcodes.
        public static var buffer: Kernel.IO.Uring.Buffer.Type { Kernel.IO.Uring.Buffer.self }
    }

#endif

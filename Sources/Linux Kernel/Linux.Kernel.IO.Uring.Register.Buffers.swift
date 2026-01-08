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

#if canImport(Glibc) || canImport(Musl)
    public import Kernel_Primitives

    extension Kernel.IO.Uring.Register {
        /// Buffer registration opcodes.
        public struct Buffers {
            /// Registers buffers for zero-copy I/O.
            ///
            /// Pre-pins buffer memory in the kernel, avoiding per-operation
            /// memory registration overhead.
            ///
            /// - Linux: `IORING_REGISTER_BUFFERS`
            public static let register = Opcode(rawValue: 0)

            /// Unregisters previously registered buffers.
            ///
            /// - Linux: `IORING_UNREGISTER_BUFFERS`
            public static let unregister = Opcode(rawValue: 1)
        }
    }

    extension Kernel.IO.Uring.Register.Opcode {
        /// Access to buffer registration opcodes.
        public static var buffers: Kernel.IO.Uring.Register.Buffers.Type { Kernel.IO.Uring.Register.Buffers.self }
    }

#endif

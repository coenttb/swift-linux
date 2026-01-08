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

    extension Kernel.IO.Uring {
        /// Memory operation opcodes.
        public struct Memory {
            /// Memory advice.
            public static let madvise = Opcode(rawValue: 25)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to memory operation opcodes.
        public static var memory: Kernel.IO.Uring.Memory.Type { Kernel.IO.Uring.Memory.self }
    }

#endif

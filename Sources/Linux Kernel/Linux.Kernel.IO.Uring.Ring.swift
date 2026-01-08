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
        /// Ring operation opcodes.
        public struct Ring {
            /// Send message between rings.
            public static let msg = Opcode(rawValue: 40)

            /// Uring command.
            public static let cmd = Opcode(rawValue: 46)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to ring operation opcodes.
        public static var ring: Kernel.IO.Uring.Ring.Type { Kernel.IO.Uring.Ring.self }
    }

#endif

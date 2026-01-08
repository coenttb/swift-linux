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
        /// Send zero-copy operation opcodes.
        public struct Send {
            /// Access to zero-copy send operations.
            public static var zero: Zero.Type { Zero.self }

            /// Zero-copy send operations.
            public struct Zero {
                /// Send with zero-copy (kernel 6.0+).
                public static let copy = Opcode(rawValue: 47)

                /// Sendmsg with zero-copy (kernel 6.1+).
                public static let msg = Opcode(rawValue: 48)
            }
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to send zero-copy operation opcodes.
        public static var send: Kernel.IO.Uring.Send.Type { Kernel.IO.Uring.Send.self }
    }

#endif

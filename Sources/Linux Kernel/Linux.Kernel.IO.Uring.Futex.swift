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
public import Kernel_Primitives

#if canImport(Glibc) || canImport(Musl)

    extension Kernel.IO.Uring {
        /// Futex operation opcodes (kernel 6.7+).
        public struct Futex {
            /// Futex wait (kernel 6.7+).
            public static let wait = Opcode(rawValue: 51)

            /// Futex wake (kernel 6.7+).
            public static let wake = Opcode(rawValue: 52)

            /// Futex wait v (kernel 6.7+).
            public static let waitv = Opcode(rawValue: 53)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to futex operation opcodes.
        public static var futex: Kernel.IO.Uring.Futex.Type { Kernel.IO.Uring.Futex.self }
    }

#endif

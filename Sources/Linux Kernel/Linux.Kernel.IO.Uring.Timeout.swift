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
        /// Timeout operation opcodes.
        public struct Timeout {
            /// Timeout operation.
            public static let standard = Opcode(rawValue: 11)

            /// Remove existing timeout.
            public static let remove = Opcode(rawValue: 12)

            /// Link timeout to previous SQE.
            public static let link = Opcode(rawValue: 15)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to timeout operation opcodes.
        public static var timeout: Kernel.IO.Uring.Timeout.Type { Kernel.IO.Uring.Timeout.self }
    }

#endif

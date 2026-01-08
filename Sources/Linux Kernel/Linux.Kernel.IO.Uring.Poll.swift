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
        /// Poll operation opcodes.
        public struct Poll {
            /// Poll for events on fd.
            public static let add = Opcode(rawValue: 6)

            /// Remove existing poll request.
            public static let remove = Opcode(rawValue: 7)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to poll operation opcodes.
        public static var poll: Kernel.IO.Uring.Poll.Type { Kernel.IO.Uring.Poll.self }
    }

#endif

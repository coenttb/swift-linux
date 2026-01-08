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
        /// Sync operation opcodes.
        public struct Sync {
            /// File sync (fsync).
            public static let file = Opcode(rawValue: 3)

            /// Sync file data range.
            public static let fileRange = Opcode(rawValue: 8)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to sync operation opcodes.
        public static var sync: Kernel.IO.Uring.Sync.Type { Kernel.IO.Uring.Sync.self }
    }

#endif

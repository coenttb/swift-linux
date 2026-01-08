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
        /// Write operation opcodes.
        public struct Write {
            /// Write to file (pwrite-like, kernel 5.6+).
            public static let standard = Opcode(rawValue: 23)

            /// Vectored write (writev).
            public static let vectored = Opcode(rawValue: 2)

            /// Write to fixed buffers (writev with registered buffers).
            public static let fixed = Opcode(rawValue: 5)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to write operation opcodes.
        public static var write: Kernel.IO.Uring.Write.Type { Kernel.IO.Uring.Write.self }
    }

#endif

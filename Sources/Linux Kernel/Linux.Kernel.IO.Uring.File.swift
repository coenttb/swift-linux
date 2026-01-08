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
        /// File operation opcodes.
        public struct File {
            /// Open file.
            public static let openat = Opcode(rawValue: 18)

            /// Open file relative to directory (openat2).
            public static let openat2 = Opcode(rawValue: 28)

            /// Get file status.
            public static let statx = Opcode(rawValue: 21)

            /// Allocate disk space.
            public static let fallocate = Opcode(rawValue: 17)

            /// Memory advice for file.
            public static let fadvise = Opcode(rawValue: 24)

            /// Ftruncate (kernel 6.9+).
            public static let ftruncate = Opcode(rawValue: 55)

            /// Rename file.
            public static let renameat = Opcode(rawValue: 35)

            /// Unlink file.
            public static let unlinkat = Opcode(rawValue: 36)

            /// Create directory.
            public static let mkdirat = Opcode(rawValue: 37)

            /// Create symbolic link.
            public static let symlinkat = Opcode(rawValue: 38)

            /// Create hard link.
            public static let linkat = Opcode(rawValue: 39)

            /// Update registered files.
            public static let filesUpdate = Opcode(rawValue: 20)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to file operation opcodes.
        public static var file: Kernel.IO.Uring.File.Type { Kernel.IO.Uring.File.self }
    }

#endif

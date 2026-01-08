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
        /// File registration opcodes.
        public struct Files {
            /// Registers file descriptors for fast access.
            ///
            /// Allows using fd indices instead of raw descriptors in SQEs
            /// (with `.fixedFile` flag), avoiding fd lookup overhead.
            ///
            /// - Linux: `IORING_REGISTER_FILES`
            public static let register = Opcode(rawValue: 2)

            /// Unregisters previously registered files.
            ///
            /// - Linux: `IORING_UNREGISTER_FILES`
            public static let unregister = Opcode(rawValue: 3)

            /// Updates registered files (add/remove without full re-register).
            ///
            /// - Linux: `IORING_REGISTER_FILES_UPDATE`
            public static let update = Opcode(rawValue: 6)
        }
    }

    extension Kernel.IO.Uring.Register.Opcode {
        /// Access to file registration opcodes.
        public static var files: Kernel.IO.Uring.Register.Files.Type { Kernel.IO.Uring.Register.Files.self }
    }

#endif

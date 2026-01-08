// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-kernel open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-kernel project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//
public import Kernel_Primitives

#if canImport(Glibc) || canImport(Musl)

    #if canImport(Glibc)
        public import Glibc
        public import CLinuxShim
    #elseif canImport(Musl)
        public import Musl
    #endif

    extension Kernel.IO.Uring.Submission.Queue.Entry {
        /// Accessor for operation-specific properties.
        public var op: Op {
            get { Op(entry: self) }
            set { cValue.rw_flags = newValue.flags }
        }

        /// Operation-specific properties for submission entry.
        public struct Op: Sendable {
            /// Operation-specific flags.
            ///
            /// Note: Uses Int32 to match Linux kernel's `__kernel_rwf_t` type.
            public var flags: Int32

            init(entry: Kernel.IO.Uring.Submission.Queue.Entry) {
                self.flags = entry.cValue.rw_flags
            }

            /// Creates an Op with the given flags.
            public init(flags: Int32) {
                self.flags = flags
            }
        }
    }

#endif

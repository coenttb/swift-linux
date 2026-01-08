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

    extension Kernel.IO.Uring.Params.Submission {
        /// Thread configuration for submission queue polling.
        public struct Thread: Sendable, Equatable {
            /// CPU affinity (when using .sqAff flag).
            public var cpu: UInt32

            /// Idle timeout in milliseconds.
            public var idle: UInt32

            /// Creates thread configuration.
            public init(cpu: UInt32 = 0, idle: UInt32 = 0) {
                self.cpu = cpu
                self.idle = idle
            }
        }
    }

#endif

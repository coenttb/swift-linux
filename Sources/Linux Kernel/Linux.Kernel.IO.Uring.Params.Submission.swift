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

    extension Kernel.IO.Uring.Params {
        /// Submission queue configuration.
        public struct Submission: Sendable, Equatable {
            /// Thread configuration for submission queue polling.
            public var thread: Thread

            /// Creates submission configuration.
            public init(thread: Thread = Thread()) {
                self.thread = thread
            }
        }
    }

#endif

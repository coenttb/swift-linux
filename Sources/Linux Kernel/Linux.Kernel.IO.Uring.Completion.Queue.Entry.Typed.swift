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

    extension Kernel.IO.Uring.Completion.Queue.Entry {
        /// Accessor for typed flag operations.
        public var typed: Typed { Typed(entry: self) }

        /// Typed accessor for flags.
        public struct Typed: Sendable {
            let entry: Kernel.IO.Uring.Completion.Queue.Entry

            init(entry: Kernel.IO.Uring.Completion.Queue.Entry) {
                self.entry = entry
            }

            /// The entry flags as a typed value.
            public var flags: Flags {
                Flags(rawValue: entry.flags)
            }
        }

        /// Whether this entry indicates more completions will follow (multishot).
        public var hasMore: Bool {
            typed.flags.contains(.more)
        }
    }

#endif

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

    #if canImport(Glibc)
        public import Glibc
        public import CLinuxShim
    #elseif canImport(Musl)
        public import Musl
    #endif

    extension Kernel.IOUring {
        /// Configuration and result parameters for io_uring setup.
        ///
        /// This struct serves dual purpose: you provide setup flags and thread
        /// configuration as input, and the kernel fills in ring sizes, offsets,
        /// and feature flags as output.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Create params with configuration
        /// var params = Kernel.IOUring.Params(
        ///     flags: [.sqPoll, .singleIssuer],
        ///     submission: .init(thread: .init(idle: 1000))
        /// )
        ///
        /// // Setup fills in kernel-provided values
        /// let fd = try Kernel.IOUring.setup(entries: 256, params: &params)
        ///
        /// // Now params contains ring offsets for mmap
        /// print("SQ entries: \(params.sqEntries)")
        /// print("CQ entries: \(params.cqEntries)")
        /// ```
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IOUring``
        /// - ``Kernel/IOUring/Setup/Flags``
        public struct Params: Sendable, Equatable {
            /// Number of submission queue entries (filled by kernel).
            public private(set) var sqEntries: UInt32

            /// Number of completion queue entries (filled by kernel).
            public private(set) var cqEntries: UInt32

            /// Setup flags.
            public var flags: Setup.Flags

            /// Submission queue thread configuration.
            public var submission: Submission

            /// Ring features supported by kernel (filled by kernel).
            public private(set) var features: UInt32

            /// Submission queue ring offset info (filled by kernel).
            public private(set) var sqOff: Kernel.IOUring.Submission.Queue.Offsets

            /// Completion queue ring offset info (filled by kernel).
            public private(set) var cqOff: Kernel.IOUring.Completion.Queue.Offsets

            /// Creates io_uring parameters for setup.
            ///
            /// - Parameters:
            ///   - flags: Setup flags to configure the ring.
            ///   - submission: Submission queue thread configuration.
            public init(
                flags: Setup.Flags = [],
                submission: Submission = Submission()
            ) {
                self.sqEntries = 0
                self.cqEntries = 0
                self.flags = flags
                self.submission = submission
                self.features = 0
                self.sqOff = Kernel.IOUring.Submission.Queue.Offsets()
                self.cqOff = Kernel.IOUring.Completion.Queue.Offsets()
            }

            /// Creates params from the C struct (after setup).
            internal init(_ cParams: io_uring_params) {
                self.sqEntries = cParams.sq_entries
                self.cqEntries = cParams.cq_entries
                self.flags = Setup.Flags(rawValue: cParams.flags)
                self.submission = Submission(
                    thread: Submission.Thread(
                        cpu: cParams.sq_thread_cpu,
                        idle: cParams.sq_thread_idle
                    )
                )
                self.features = cParams.features
                self.sqOff = Kernel.IOUring.Submission.Queue.Offsets(cParams.sq_off)
                self.cqOff = Kernel.IOUring.Completion.Queue.Offsets(cParams.cq_off)
            }

            /// Converts to the C io_uring_params struct.
            internal var cValue: io_uring_params {
                var params = io_uring_params()
                params.flags = flags.rawValue
                params.sq_thread_cpu = submission.thread.cpu
                params.sq_thread_idle = submission.thread.idle
                return params
            }
        }
    }

    // MARK: - Submission Thread Configuration

    extension Kernel.IOUring.Params {
        /// Submission queue configuration.
        public struct Submission: Sendable, Equatable {
            /// Thread configuration for submission queue polling.
            public var thread: Thread

            /// Creates submission configuration.
            public init(thread: Thread = Thread()) {
                self.thread = thread
            }

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
    }

#endif

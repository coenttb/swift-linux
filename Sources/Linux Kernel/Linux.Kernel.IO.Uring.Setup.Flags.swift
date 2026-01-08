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

    extension Kernel.IO.Uring.Setup {
        /// Configuration flags for io_uring instance creation.
        ///
        /// These flags control how the io_uring instance behaves, including
        /// polling modes, thread affinity, and ring sizes. Many flags require
        /// specific kernel versions.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Create a high-performance ring with kernel-side polling
        /// let params = try Kernel.IO.Uring.Setup.setup(
        ///     entries: 256,
        ///     flags: [.sqPoll, .singleIssuer]
        /// )
        ///
        /// // Create a ring with custom CQ size
        /// let params = try Kernel.IO.Uring.Setup.setup(
        ///     entries: 64,
        ///     flags: [.cqSize],
        ///     cqEntries: 256
        /// )
        /// ```
        ///
        /// ## Kernel Version Requirements
        ///
        /// | Flag | Minimum Kernel |
        /// |------|----------------|
        /// | `.sqPoll` | 5.1 |
        /// | `.coopTaskrun` | 5.19 |
        /// | `.sqe128` | 5.19 |
        /// | `.singleIssuer` | 6.0 |
        /// | `.deferTaskrun` | 6.1 |
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring``
        /// - ``Kernel/IO/Uring/Setup``
        public struct Flags: OptionSet, Sendable {
            public let rawValue: UInt32

            public init(rawValue: UInt32) {
                self.rawValue = rawValue
            }
        }
    }

    extension Kernel.IO.Uring.Setup.Flags {
        /// Enables busy-waiting for I/O completion.
        ///
        /// The kernel will poll for completions instead of using interrupts.
        /// Best for devices that support polling (NVMe). Increases CPU usage
        /// but reduces latency.
        ///
        /// - Linux: `IORING_SETUP_IOPOLL`
        public static let ioPoll = Self(rawValue: 1 << 0)

        /// Creates a kernel thread to poll the submission queue.
        ///
        /// Eliminates the need to call `io_uring_enter` for submissions,
        /// reducing syscall overhead. The kernel thread will sleep after
        /// an idle period (configurable via `sq_thread_idle`).
        ///
        /// - Note: Requires `CAP_SYS_NICE` or root for real-time priority.
        /// - Linux: `IORING_SETUP_SQPOLL`
        public static let sqPoll = Self(rawValue: 1 << 1)

        /// Pins the SQ poll thread to a specific CPU.
        ///
        /// Use with `.sqPoll` to bind the kernel polling thread to a
        /// specific CPU core. Set `sq_thread_cpu` in params to specify which CPU.
        ///
        /// - Linux: `IORING_SETUP_SQ_AFF`
        public static let sqAff = Self(rawValue: 1 << 2)

        /// Allows specifying completion queue size separately.
        ///
        /// By default, CQ size is 2× SQ size. This flag allows setting
        /// a custom CQ size via the `cq_entries` parameter. Useful when
        /// expecting many completions per submission (multishot operations).
        ///
        /// - Linux: `IORING_SETUP_CQSIZE`
        public static let cqSize = Self(rawValue: 1 << 3)

        /// Clamps ring sizes to the maximum allowed.
        ///
        /// If requested sizes exceed system limits, they're clamped instead
        /// of failing. Without this flag, oversized requests return `EINVAL`.
        ///
        /// - Linux: `IORING_SETUP_CLAMP`
        public static let clamp = Self(rawValue: 1 << 4)

        /// Shares the async backend with another io_uring instance.
        ///
        /// Multiple rings share worker threads, reducing resource usage.
        /// Pass the fd of the existing ring in `wq_fd` parameter.
        ///
        /// - Linux: `IORING_SETUP_ATTACH_WQ`
        public static let attachWq = Self(rawValue: 1 << 5)

        /// Creates the ring in a disabled state.
        ///
        /// The ring won't process submissions until enabled via
        /// `IORING_REGISTER_ENABLE_RINGS`. Useful for setting up
        /// resources before processing begins.
        ///
        /// - Linux: `IORING_SETUP_R_DISABLED`
        public static let rDisabled = Self(rawValue: 1 << 6)

        /// Allows the kernel to choose the SQ thread CPU.
        ///
        /// When used with `.sqPoll`, lets the kernel select an appropriate
        /// CPU for the polling thread instead of requiring `.sqAff`.
        ///
        /// - Linux: `IORING_SETUP_SUBMIT_ALL`
        public static let submitAll = Self(rawValue: 1 << 7)

        /// Enables cooperative task running (kernel 5.19+).
        ///
        /// Completions are processed cooperatively, reducing context switches.
        /// Best for single-threaded applications.
        ///
        /// - Linux: `IORING_SETUP_COOP_TASKRUN`
        public static let coopTaskrun = Self(rawValue: 1 << 8)

        /// Enables single-issuer task running mode (kernel 5.19+).
        ///
        /// Optimizes for the common case where only one task submits to the ring.
        /// Combined with `.coopTaskrun` for best performance.
        ///
        /// - Linux: `IORING_SETUP_TASKRUN_FLAG`
        public static let taskrunFlag = Self(rawValue: 1 << 9)

        /// Uses 128-byte SQE format (kernel 5.19+).
        ///
        /// Extended SQE format for operations needing more space
        /// (e.g., `IORING_OP_URING_CMD`).
        ///
        /// - Linux: `IORING_SETUP_SQE128`
        public static let sqe128 = Self(rawValue: 1 << 10)

        /// Uses 32-byte CQE format (kernel 5.19+).
        ///
        /// Extended CQE format providing more space for result data.
        /// Required by some operations.
        ///
        /// - Linux: `IORING_SETUP_CQE32`
        public static let cqe32 = Self(rawValue: 1 << 11)

        /// Hints that only one task will submit (kernel 6.0+).
        ///
        /// Enables additional optimizations when the ring is accessed
        /// from a single thread/task. Violations may cause undefined behavior.
        ///
        /// - Linux: `IORING_SETUP_SINGLE_ISSUER`
        public static let singleIssuer = Self(rawValue: 1 << 12)

        /// Defers task running until explicit enter (kernel 6.1+).
        ///
        /// Completions aren't processed automatically; you must call
        /// `io_uring_enter` with `IORING_ENTER_GETEVENTS`. Gives full
        /// control over when work is processed.
        ///
        /// - Linux: `IORING_SETUP_DEFER_TASKRUN`
        public static let deferTaskrun = Self(rawValue: 1 << 13)
    }

#endif

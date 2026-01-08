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
        /// Opcodes specifying which operation to submit to io_uring.
        ///
        /// Each opcode corresponds to an `IORING_OP_*` constant from `<linux/io_uring.h>`.
        /// When preparing a submission queue entry (SQE), the opcode determines what
        /// the kernel will do when processing that entry.
        ///
        /// ## Usage
        ///
        /// ```swift
        /// // Prepare a read operation
        /// sqe.opcode = .read.standard
        /// sqe.fd = fd.rawValue
        /// sqe.addr = UInt64(UInt(bitPattern: buffer.baseAddress))
        /// sqe.len = UInt32(buffer.count)
        /// sqe.off = offset
        /// ```
        ///
        /// ## Kernel Version Requirements
        ///
        /// Some opcodes require newer kernel versions:
        /// - `.read.standard`/`.write.standard`: 5.6+
        /// - `.send.zero.copy`: 6.0+
        /// - `.futex.wait`/`.futex.wake`: 6.7+
        /// - `.file.ftruncate`: 6.9+
        ///
        /// ## See Also
        ///
        /// - ``Kernel/IO/Uring``
        /// - ``Kernel/IO/Uring/Submission``
        public struct Opcode: RawRepresentable, Sendable, Equatable, Hashable {
            public let rawValue: UInt8

            public init(rawValue: UInt8) {
                self.rawValue = rawValue
            }
        }
    }

    // MARK: - Basic Operations

    extension Kernel.IO.Uring.Opcode {
        /// No operation (used for wakeup or testing).
        public static let nop = Self(rawValue: 0)

        /// Close file descriptor.
        public static let close = Self(rawValue: 19)
    }

    // MARK: - CustomStringConvertible

    extension Kernel.IO.Uring.Opcode: CustomStringConvertible {
        public var description: String {
            switch self {
            case .nop: return "NOP"
            case .read.standard: return "READ"
            case .read.vectored: return "READV"
            case .write.standard: return "WRITE"
            case .write.vectored: return "WRITEV"
            case .sync.file: return "FSYNC"
            case .socket.accept: return "ACCEPT"
            case .socket.connect: return "CONNECT"
            case .socket.send: return "SEND"
            case .socket.receive: return "RECV"
            case .close: return "CLOSE"
            case .cancel.async: return "ASYNC_CANCEL"
            default: return "OPCODE(\(rawValue))"
            }
        }
    }

#endif

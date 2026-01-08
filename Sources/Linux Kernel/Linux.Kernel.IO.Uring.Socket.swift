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

    extension Kernel.IO.Uring {
        /// Socket operation opcodes.
        public struct Socket {
            /// Accept connection on socket.
            public static let accept = Opcode(rawValue: 13)

            /// Connect socket to address.
            public static let connect = Opcode(rawValue: 16)

            /// Send data on socket.
            public static let send = Opcode(rawValue: 26)

            /// Receive data from socket.
            public static let receive = Opcode(rawValue: 27)

            /// Send message on socket.
            public static let sendMessage = Opcode(rawValue: 9)

            /// Receive message from socket.
            public static let receiveMessage = Opcode(rawValue: 10)

            /// Shutdown socket.
            public static let shutdown = Opcode(rawValue: 34)

            /// Socket operation.
            public static let create = Opcode(rawValue: 45)
        }
    }

    extension Kernel.IO.Uring.Opcode {
        /// Access to socket operation opcodes.
        public static var socket: Kernel.IO.Uring.Socket.Type { Kernel.IO.Uring.Socket.self }
    }

#endif

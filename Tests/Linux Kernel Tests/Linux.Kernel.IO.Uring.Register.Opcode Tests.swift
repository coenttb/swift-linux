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

#if os(Linux)
    import StandardsTestSupport
    import Testing

    import Kernel_Primitives
    @testable import Linux_Kernel

    extension Kernel.IO.Uring.Register.Opcode {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Register.Opcode.Test.Unit {
        @Test("Register.Opcode type exists")
        func typeExists() {
            let _: Kernel.IO.Uring.Register.Opcode.Type = Kernel.IO.Uring.Register.Opcode.self
        }

        @Test("Register.Opcode from rawValue")
        func fromRawValue() {
            let opcode = Kernel.IO.Uring.Register.Opcode(rawValue: 42)
            #expect(opcode.rawValue == 42)
        }

        @Test("buffers.register constant")
        func buffersRegisterConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.buffers.register.rawValue == 0)
        }

        @Test("buffers.unregister constant")
        func buffersUnregisterConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.buffers.unregister.rawValue == 1)
        }

        @Test("files.register constant")
        func filesRegisterConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.files.register.rawValue == 2)
        }

        @Test("files.unregister constant")
        func filesUnregisterConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.files.unregister.rawValue == 3)
        }

        @Test("eventfd.register constant")
        func eventfdRegisterConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.eventfd.register.rawValue == 4)
        }

        @Test("eventfd.unregister constant")
        func eventfdUnregisterConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.eventfd.unregister.rawValue == 5)
        }

        @Test("files.update constant")
        func filesUpdateConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.files.update.rawValue == 6)
        }

        @Test("eventfd.async constant")
        func eventfdAsyncConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.eventfd.async.rawValue == 7)
        }

        @Test("probe.register constant")
        func probeRegisterConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.probe.register.rawValue == 8)
        }

        @Test("personality.register constant")
        func personalityRegisterConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.personality.register.rawValue == 9)
        }

        @Test("personality.unregister constant")
        func personalityUnregisterConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.personality.unregister.rawValue == 10)
        }

        @Test("rings.enable constant")
        func ringsEnableConstant() {
            #expect(Kernel.IO.Uring.Register.Opcode.rings.enable.rawValue == 11)
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IO.Uring.Register.Opcode.Test.Unit {
        @Test("Register.Opcode is Sendable")
        func isSendable() {
            let opcode: any Sendable = Kernel.IO.Uring.Register.Opcode.buffers.register
            #expect(opcode is Kernel.IO.Uring.Register.Opcode)
        }

        @Test("Register.Opcode is Equatable")
        func isEquatable() {
            let a = Kernel.IO.Uring.Register.Opcode.files.register
            let b = Kernel.IO.Uring.Register.Opcode.files.register
            let c = Kernel.IO.Uring.Register.Opcode.files.unregister
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Register.Opcode is Hashable")
        func isHashable() {
            var set = Set<Kernel.IO.Uring.Register.Opcode>()
            set.insert(.buffers.register)
            set.insert(.files.register)
            set.insert(.buffers.register)  // duplicate
            #expect(set.count == 2)
        }

        @Test("Register.Opcode is RawRepresentable")
        func isRawRepresentable() {
            let opcode = Kernel.IO.Uring.Register.Opcode(rawValue: 4)
            #expect(opcode == .eventfd.register)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IO.Uring.Register.Opcode.Test.EdgeCase {
        @Test("all opcodes have unique rawValues")
        func uniqueRawValues() {
            let opcodes: [Kernel.IO.Uring.Register.Opcode] = [
                .buffers.register,
                .buffers.unregister,
                .files.register,
                .files.unregister,
                .eventfd.register,
                .eventfd.unregister,
                .files.update,
                .eventfd.async,
                .probe.register,
                .personality.register,
                .personality.unregister,
                .rings.enable,
            ]
            let rawValues = opcodes.map(\.rawValue)
            let uniqueValues = Set(rawValues)
            #expect(rawValues.count == uniqueValues.count)
        }

        @Test("rawValue roundtrip")
        func rawValueRoundtrip() {
            for rawValue: UInt32 in [0, 1, 5, 11] {
                let opcode = Kernel.IO.Uring.Register.Opcode(rawValue: rawValue)
                #expect(opcode.rawValue == rawValue)
            }
        }
    }
#endif

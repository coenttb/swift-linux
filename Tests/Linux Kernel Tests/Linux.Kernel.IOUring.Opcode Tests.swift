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


    extension Kernel.IOUring.Opcode {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Opcode.Test.Unit {
        @Test("Opcode from rawValue")
        func rawValueInit() {
            let opcode = Kernel.IOUring.Opcode(rawValue: 22)
            #expect(opcode.rawValue == 22)
        }

        @Test("nop has rawValue 0")
        func nopRawValue() {
            #expect(Kernel.IOUring.Opcode.nop.rawValue == 0)
        }

        @Test("readv has rawValue 1")
        func readvRawValue() {
            #expect(Kernel.IOUring.Opcode.readv.rawValue == 1)
        }

        @Test("writev has rawValue 2")
        func writevRawValue() {
            #expect(Kernel.IOUring.Opcode.writev.rawValue == 2)
        }

        @Test("read has rawValue 22")
        func readRawValue() {
            #expect(Kernel.IOUring.Opcode.read.rawValue == 22)
        }

        @Test("write has rawValue 23")
        func writeRawValue() {
            #expect(Kernel.IOUring.Opcode.write.rawValue == 23)
        }

        @Test("close has rawValue 19")
        func closeRawValue() {
            #expect(Kernel.IOUring.Opcode.close.rawValue == 19)
        }

        @Test("accept has rawValue 13")
        func acceptRawValue() {
            #expect(Kernel.IOUring.Opcode.accept.rawValue == 13)
        }

        @Test("connect has rawValue 16")
        func connectRawValue() {
            #expect(Kernel.IOUring.Opcode.connect.rawValue == 16)
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IOUring.Opcode.Test.Unit {
        @Test("Opcode is Sendable")
        func isSendable() {
            let opcode: any Sendable = Kernel.IOUring.Opcode.nop
            #expect(opcode is Kernel.IOUring.Opcode)
        }

        @Test("Opcode is Equatable")
        func isEquatable() {
            let a = Kernel.IOUring.Opcode.read
            let b = Kernel.IOUring.Opcode.read
            let c = Kernel.IOUring.Opcode.write
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Opcode is Hashable")
        func isHashable() {
            var set = Set<Kernel.IOUring.Opcode>()
            set.insert(.nop)
            set.insert(.read)
            set.insert(.write)
            set.insert(.nop)  // duplicate
            #expect(set.count == 3)
        }

        @Test("Opcode is RawRepresentable")
        func isRawRepresentable() {
            let opcode = Kernel.IOUring.Opcode(rawValue: 22)
            #expect(opcode.rawValue == 22)
        }

        @Test("Opcode is CustomStringConvertible")
        func isCustomStringConvertible() {
            let opcode: any CustomStringConvertible = Kernel.IOUring.Opcode.read
            #expect(opcode.description == "READ")
        }
    }

    // MARK: - Description Tests

    extension Kernel.IOUring.Opcode.Test.Unit {
        @Test("nop description")
        func nopDescription() {
            #expect(Kernel.IOUring.Opcode.nop.description == "NOP")
        }

        @Test("read description")
        func readDescription() {
            #expect(Kernel.IOUring.Opcode.read.description == "READ")
        }

        @Test("write description")
        func writeDescription() {
            #expect(Kernel.IOUring.Opcode.write.description == "WRITE")
        }

        @Test("unknown opcode description")
        func unknownDescription() {
            let opcode = Kernel.IOUring.Opcode(rawValue: 200)
            #expect(opcode.description.contains("OPCODE"))
            #expect(opcode.description.contains("200"))
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IOUring.Opcode.Test.EdgeCase {
        @Test("opcodes with same rawValue are equal")
        func sameRawValueEqual() {
            let a = Kernel.IOUring.Opcode(rawValue: 22)
            let b = Kernel.IOUring.Opcode.read
            #expect(a == b)
        }

        @Test("opcodes are distinct")
        func opcodesDistinct() {
            let opcodes: [Kernel.IOUring.Opcode] = [
                .nop, .readv, .writev, .fsync, .read, .write,
                .accept, .connect, .send, .recv, .close,
            ]

            for i in 0..<opcodes.count {
                for j in (i + 1)..<opcodes.count {
                    #expect(opcodes[i] != opcodes[j])
                }
            }
        }

        @Test("rawValue roundtrip")
        func rawValueRoundtrip() {
            for rawValue: UInt8 in [0, 1, 22, 23, 55] {
                let opcode = Kernel.IOUring.Opcode(rawValue: rawValue)
                #expect(opcode.rawValue == rawValue)
            }
        }
    }
#endif

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

    /// Tests for Kernel.IO.Uring.Register.Opcode.
    extension Kernel.IO.Uring {
        @Suite
        enum Register.OpcodeTest {
            // MARK: - Unit Tests

            @Suite struct Unit {
                @Test("Register.Opcode type exists")
                func typeExists() {
                    let _: Kernel.IO.Uring.Register.Opcode.Type = Kernel.IO.Uring.Register.Opcode.self
                }

                @Test("Register.Opcode from rawValue")
                func fromRawValue() {
                    let opcode = Kernel.IO.Uring.Register.Opcode(rawValue: 42)
                    #expect(opcode.rawValue == 42)
                }

                @Test("registerBuffers constant")
                func registerBuffersConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.registerBuffers.rawValue == 0)
                }

                @Test("unregisterBuffers constant")
                func unregisterBuffersConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.unregisterBuffers.rawValue == 1)
                }

                @Test("registerFiles constant")
                func registerFilesConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.registerFiles.rawValue == 2)
                }

                @Test("unregisterFiles constant")
                func unregisterFilesConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.unregisterFiles.rawValue == 3)
                }

                @Test("registerEventfd constant")
                func registerEventfdConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.registerEventfd.rawValue == 4)
                }

                @Test("unregisterEventfd constant")
                func unregisterEventfdConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.unregisterEventfd.rawValue == 5)
                }

                @Test("registerFilesUpdate constant")
                func registerFilesUpdateConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.registerFilesUpdate.rawValue == 6)
                }

                @Test("registerEventfdAsync constant")
                func registerEventfdAsyncConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.registerEventfdAsync.rawValue == 7)
                }

                @Test("registerProbe constant")
                func registerProbeConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.registerProbe.rawValue == 8)
                }

                @Test("registerPersonality constant")
                func registerPersonalityConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.registerPersonality.rawValue == 9)
                }

                @Test("unregisterPersonality constant")
                func unregisterPersonalityConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.unregisterPersonality.rawValue == 10)
                }

                @Test("enableRings constant")
                func enableRingsConstant() {
                    #expect(Kernel.IO.Uring.Register.Opcode.enableRings.rawValue == 11)
                }
            }

            // MARK: - Conformance Tests

            @Suite struct Conformance {
                @Test("Register.Opcode is Sendable")
                func isSendable() {
                    let opcode: any Sendable = Kernel.IO.Uring.Register.Opcode.registerBuffers
                    #expect(opcode is Kernel.IO.Uring.Register.Opcode)
                }

                @Test("Register.Opcode is Equatable")
                func isEquatable() {
                    let a = Kernel.IO.Uring.Register.Opcode.registerFiles
                    let b = Kernel.IO.Uring.Register.Opcode.registerFiles
                    let c = Kernel.IO.Uring.Register.Opcode.unregisterFiles
                    #expect(a == b)
                    #expect(a != c)
                }

                @Test("Register.Opcode is Hashable")
                func isHashable() {
                    var set = Set<Kernel.IO.Uring.Register.Opcode>()
                    set.insert(.registerBuffers)
                    set.insert(.registerFiles)
                    set.insert(.registerBuffers)  // duplicate
                    #expect(set.count == 2)
                }

                @Test("Register.Opcode is RawRepresentable")
                func isRawRepresentable() {
                    let opcode = Kernel.IO.Uring.Register.Opcode(rawValue: 4)
                    #expect(opcode == .registerEventfd)
                }
            }

            // MARK: - Edge Cases

            @Suite struct EdgeCase {
                @Test("all opcodes have unique rawValues")
                func uniqueRawValues() {
                    let opcodes: [Kernel.IO.Uring.Register.Opcode] = [
                        .registerBuffers,
                        .unregisterBuffers,
                        .registerFiles,
                        .unregisterFiles,
                        .registerEventfd,
                        .unregisterEventfd,
                        .registerFilesUpdate,
                        .registerEventfdAsync,
                        .registerProbe,
                        .registerPersonality,
                        .unregisterPersonality,
                        .enableRings,
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
        }
    }
#endif

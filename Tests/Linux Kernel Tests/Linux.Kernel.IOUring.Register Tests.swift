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

    /// Tests for Kernel.IOUring.RegisterOpcode.
    extension Kernel.IOUring {
        @Suite
        enum RegisterOpcodeTest {
            // MARK: - Unit Tests

            @Suite struct Unit {
                @Test("RegisterOpcode type exists")
                func typeExists() {
                    let _: Kernel.IOUring.RegisterOpcode.Type = Kernel.IOUring.RegisterOpcode.self
                }

                @Test("RegisterOpcode from rawValue")
                func fromRawValue() {
                    let opcode = Kernel.IOUring.RegisterOpcode(rawValue: 42)
                    #expect(opcode.rawValue == 42)
                }

                @Test("registerBuffers constant")
                func registerBuffersConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.registerBuffers.rawValue == 0)
                }

                @Test("unregisterBuffers constant")
                func unregisterBuffersConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.unregisterBuffers.rawValue == 1)
                }

                @Test("registerFiles constant")
                func registerFilesConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.registerFiles.rawValue == 2)
                }

                @Test("unregisterFiles constant")
                func unregisterFilesConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.unregisterFiles.rawValue == 3)
                }

                @Test("registerEventfd constant")
                func registerEventfdConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.registerEventfd.rawValue == 4)
                }

                @Test("unregisterEventfd constant")
                func unregisterEventfdConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.unregisterEventfd.rawValue == 5)
                }

                @Test("registerFilesUpdate constant")
                func registerFilesUpdateConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.registerFilesUpdate.rawValue == 6)
                }

                @Test("registerEventfdAsync constant")
                func registerEventfdAsyncConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.registerEventfdAsync.rawValue == 7)
                }

                @Test("registerProbe constant")
                func registerProbeConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.registerProbe.rawValue == 8)
                }

                @Test("registerPersonality constant")
                func registerPersonalityConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.registerPersonality.rawValue == 9)
                }

                @Test("unregisterPersonality constant")
                func unregisterPersonalityConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.unregisterPersonality.rawValue == 10)
                }

                @Test("enableRings constant")
                func enableRingsConstant() {
                    #expect(Kernel.IOUring.RegisterOpcode.enableRings.rawValue == 11)
                }
            }

            // MARK: - Conformance Tests

            @Suite struct Conformance {
                @Test("RegisterOpcode is Sendable")
                func isSendable() {
                    let opcode: any Sendable = Kernel.IOUring.RegisterOpcode.registerBuffers
                    #expect(opcode is Kernel.IOUring.RegisterOpcode)
                }

                @Test("RegisterOpcode is Equatable")
                func isEquatable() {
                    let a = Kernel.IOUring.RegisterOpcode.registerFiles
                    let b = Kernel.IOUring.RegisterOpcode.registerFiles
                    let c = Kernel.IOUring.RegisterOpcode.unregisterFiles
                    #expect(a == b)
                    #expect(a != c)
                }

                @Test("RegisterOpcode is Hashable")
                func isHashable() {
                    var set = Set<Kernel.IOUring.RegisterOpcode>()
                    set.insert(.registerBuffers)
                    set.insert(.registerFiles)
                    set.insert(.registerBuffers)  // duplicate
                    #expect(set.count == 2)
                }

                @Test("RegisterOpcode is RawRepresentable")
                func isRawRepresentable() {
                    let opcode = Kernel.IOUring.RegisterOpcode(rawValue: 4)
                    #expect(opcode == .registerEventfd)
                }
            }

            // MARK: - Edge Cases

            @Suite struct EdgeCase {
                @Test("all opcodes have unique rawValues")
                func uniqueRawValues() {
                    let opcodes: [Kernel.IOUring.RegisterOpcode] = [
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
                        let opcode = Kernel.IOUring.RegisterOpcode(rawValue: rawValue)
                        #expect(opcode.rawValue == rawValue)
                    }
                }
            }
        }
    }
#endif

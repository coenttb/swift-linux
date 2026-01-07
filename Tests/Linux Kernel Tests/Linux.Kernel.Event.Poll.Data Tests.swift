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
    #if canImport(Glibc)
        import Glibc
    #elseif canImport(Musl)
        import Musl
    #endif

    import StandardsTestSupport
    import Testing

    import Kernel_Primitives
    @testable import Linux_Kernel

    // Kernel.Event.Poll.Data is a typealias to Tagged<Kernel.Event.Poll, UInt64>
    // The #TestSuites macro cannot be used directly on typealiases

    @Suite("Kernel.Event.Poll.Data Tests")
    struct EventPollDataTests {

        // MARK: - Unit Tests

        @Test("zero constant equals 0")
        func zeroConstant() {
            let zero = Kernel.Event.Poll.Data.zero
            #expect(zero == 0)
        }

        @Test("init from UInt64 stores value")
        func initFromUInt64() {
            let data = Kernel.Event.Poll.Data(42)
            #expect(data == 42)
        }

        @Test("literal initialization works")
        func literalInit() {
            let data: Kernel.Event.Poll.Data = 100
            #expect(data == 100)
        }

        // MARK: - Pointer Conversion Tests

        @Test("init from raw pointer preserves bitPattern")
        func initFromRawPointer() {
            var value: Int = 42
            let data = withUnsafePointer(to: &value) { ptr in
                Kernel.Event.Poll.Data(UnsafeRawPointer(ptr))
            }
            #expect(data != 0)
        }

        @Test("init from typed pointer preserves bitPattern")
        func initFromTypedPointer() {
            var value: Int = 42
            let data = withUnsafePointer(to: &value) { ptr in
                Kernel.Event.Poll.Data(pointer: ptr)
            }
            #expect(data != 0)
        }

        @Test("init from mutable typed pointer preserves bitPattern")
        func initFromMutableTypedPointer() {
            var value: Int = 42
            let data = withUnsafeMutablePointer(to: &value) { ptr in
                Kernel.Event.Poll.Data(pointer: ptr)
            }
            #expect(data != 0)
        }

        @Test("pointer roundtrip preserves address")
        func pointerRoundtrip() {
            var value: Int = 42
            withUnsafeMutablePointer(to: &value) { ptr in
                let originalBitPattern = UInt(bitPattern: ptr)
                let data = Kernel.Event.Poll.Data(pointer: ptr)
                #expect(data.rawValue == UInt64(originalBitPattern))
            }
        }

        // MARK: - Conformance Tests

        @Test("Data is Sendable")
        func isSendable() {
            let data: any Sendable = Kernel.Event.Poll.Data.zero
            #expect(data is Kernel.Event.Poll.Data)
        }

        @Test("Data is Equatable")
        func isEquatable() {
            let a = Kernel.Event.Poll.Data(42)
            let b = Kernel.Event.Poll.Data(42)
            let c = Kernel.Event.Poll.Data(0)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Data is Hashable")
        func isHashable() {
            var set = Set<Kernel.Event.Poll.Data>()
            set.insert(Kernel.Event.Poll.Data(1))
            set.insert(Kernel.Event.Poll.Data(2))
            set.insert(Kernel.Event.Poll.Data(1))  // duplicate
            #expect(set.count == 2)
        }

        // MARK: - Edge Cases

        @Test("UInt64.max is preserved")
        func uint64MaxPreserved() {
            let data = Kernel.Event.Poll.Data(UInt64.max)
            #expect(data.rawValue == UInt64.max)
        }

        @Test("large values are preserved")
        func largeValues() {
            let largeValue: UInt64 = 0x7FFF_FFFF_FFFF_FFFF
            let data = Kernel.Event.Poll.Data(largeValue)
            #expect(data.rawValue == largeValue)
        }
    }
#endif

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

    extension Kernel.IOUring.Operation.Data {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Operation.Data.Test.Unit {
        @Test("Data type exists")
        func typeExists() {
            let _: Kernel.IOUring.Operation.Data.Type = Kernel.IOUring.Operation.Data.self
        }

        @Test("Data from UInt64")
        func fromUInt64() {
            let data = Kernel.IOUring.Operation.Data(42)
            #expect(data.rawValue == 42)
        }

        @Test("Data.zero constant")
        func zeroConstant() {
            let zero = Kernel.IOUring.Operation.Data.zero
            #expect(zero.rawValue == 0)
        }
    }

    // MARK: - Pointer Conversion Tests

    extension Kernel.IOUring.Operation.Data.Test.Unit {
        @Test("Data from UnsafeRawPointer")
        func fromRawPointer() {
            var value: Int = 42
            withUnsafePointer(to: &value) { ptr in
                let data = Kernel.IOUring.Operation.Data(ptr)
                #expect(data.rawValue == UInt64(UInt(bitPattern: ptr)))
            }
        }

        @Test("Data from typed pointer")
        func fromTypedPointer() {
            var value: Int = 42
            withUnsafePointer(to: &value) { ptr in
                let data = Kernel.IOUring.Operation.Data(pointer: ptr)
                #expect(data.rawValue == UInt64(UInt(bitPattern: ptr)))
            }
        }

        @Test("Data from mutable typed pointer")
        func fromMutableTypedPointer() {
            var value: Int = 42
            withUnsafeMutablePointer(to: &value) { ptr in
                let data = Kernel.IOUring.Operation.Data(pointer: ptr)
                #expect(data.rawValue == UInt64(UInt(bitPattern: ptr)))
            }
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IOUring.Operation.Data.Test.Unit {
        @Test("Data is Sendable")
        func isSendable() {
            let data: any Sendable = Kernel.IOUring.Operation.Data.zero
            #expect(data is Kernel.IOUring.Operation.Data)
        }

        @Test("Data is Equatable")
        func isEquatable() {
            let a = Kernel.IOUring.Operation.Data(100)
            let b = Kernel.IOUring.Operation.Data(100)
            let c = Kernel.IOUring.Operation.Data(200)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Data is Hashable")
        func isHashable() {
            var set = Set<Kernel.IOUring.Operation.Data>()
            set.insert(.zero)
            set.insert(Kernel.IOUring.Operation.Data(1))
            set.insert(.zero)  // duplicate
            #expect(set.count == 2)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IOUring.Operation.Data.Test.EdgeCase {
        @Test("Data max value")
        func maxValue() {
            let data = Kernel.IOUring.Operation.Data(UInt64.max)
            #expect(data.rawValue == UInt64.max)
        }

        @Test("Data rawValue roundtrip")
        func rawValueRoundtrip() {
            for value: UInt64 in [0, 1, 100, 0xDEAD_BEEF, UInt64.max] {
                let data = Kernel.IOUring.Operation.Data(value)
                #expect(data.rawValue == value)
            }
        }
    }
#endif

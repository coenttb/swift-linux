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

    /// Tests for Kernel.IO.Uring.Operation.Data (typealias to Tagged).
    extension Kernel.IO.Uring.Operation {
        @Suite
        enum DataTest {
            // MARK: - Unit Tests

            @Suite struct Unit {
                @Test("Data type exists")
                func typeExists() {
                    let _: Kernel.IO.Uring.Operation.Data.Type = Kernel.IO.Uring.Operation.Data.self
                }

                @Test("Data from UInt64")
                func fromUInt64() {
                    let data = Kernel.IO.Uring.Operation.Data(42)
                    #expect(data.rawValue == 42)
                }

                @Test("Data.zero constant")
                func zeroConstant() {
                    let zero = Kernel.IO.Uring.Operation.Data.zero
                    #expect(zero.rawValue == 0)
                }

                @Test("Data from UnsafeRawPointer")
                func fromRawPointer() {
                    var value: Int = 42
                    withUnsafePointer(to: &value) { ptr in
                        let data = Kernel.IO.Uring.Operation.Data(ptr)
                        #expect(data.rawValue == UInt64(UInt(bitPattern: ptr)))
                    }
                }

                @Test("Data from typed pointer")
                func fromTypedPointer() {
                    var value: Int = 42
                    withUnsafePointer(to: &value) { ptr in
                        let data = Kernel.IO.Uring.Operation.Data(pointer: ptr)
                        #expect(data.rawValue == UInt64(UInt(bitPattern: ptr)))
                    }
                }

                @Test("Data from mutable typed pointer")
                func fromMutableTypedPointer() {
                    var value: Int = 42
                    withUnsafeMutablePointer(to: &value) { ptr in
                        let data = Kernel.IO.Uring.Operation.Data(pointer: ptr)
                        #expect(data.rawValue == UInt64(UInt(bitPattern: ptr)))
                    }
                }

                @Test("Data is Sendable")
                func isSendable() {
                    let data: any Sendable = Kernel.IO.Uring.Operation.Data.zero
                    #expect(data is Kernel.IO.Uring.Operation.Data)
                }

                @Test("Data is Equatable")
                func isEquatable() {
                    let a = Kernel.IO.Uring.Operation.Data(100)
                    let b = Kernel.IO.Uring.Operation.Data(100)
                    let c = Kernel.IO.Uring.Operation.Data(200)
                    #expect(a == b)
                    #expect(a != c)
                }

                @Test("Data is Hashable")
                func isHashable() {
                    var set = Set<Kernel.IO.Uring.Operation.Data>()
                    set.insert(.zero)
                    set.insert(Kernel.IO.Uring.Operation.Data(1))
                    set.insert(.zero)  // duplicate
                    #expect(set.count == 2)
                }
            }

            // MARK: - Edge Cases

            @Suite struct EdgeCase {
                @Test("Data max value")
                func maxValue() {
                    let data = Kernel.IO.Uring.Operation.Data(UInt64.max)
                    #expect(data.rawValue == UInt64.max)
                }

                @Test("Data rawValue roundtrip")
                func rawValueRoundtrip() {
                    for value: UInt64 in [0, 1, 100, 0xDEAD_BEEF, UInt64.max] {
                        let data = Kernel.IO.Uring.Operation.Data(value)
                        #expect(data.rawValue == value)
                    }
                }
            }
        }
    }
#endif

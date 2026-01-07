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

    extension Kernel.IOUring.Length {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Length.Test.Unit {
        @Test("Length from rawValue")
        func rawValueInit() {
            let length = Kernel.IOUring.Length(rawValue: 4096)
            #expect(length.rawValue == 4096)
        }

        @Test("Length from Int")
        func intInit() {
            let length = Kernel.IOUring.Length(1024)
            #expect(length.rawValue == 1024)
        }

        @Test("Length.zero constant")
        func zeroConstant() {
            #expect(Kernel.IOUring.Length.zero.rawValue == 0)
        }

        @Test("Length integer literal")
        func integerLiteral() {
            let length: Kernel.IOUring.Length = 8192
            #expect(length.rawValue == 8192)
        }

        @Test("Length description")
        func description() {
            let length = Kernel.IOUring.Length(4096)
            #expect(length.description == "4096")
        }
    }

    // MARK: - Conformance Tests

    extension Kernel.IOUring.Length.Test.Unit {
        @Test("Length is Sendable")
        func isSendable() {
            let length: any Sendable = Kernel.IOUring.Length(1024)
            #expect(length is Kernel.IOUring.Length)
        }

        @Test("Length is Equatable")
        func isEquatable() {
            let a = Kernel.IOUring.Length(1024)
            let b = Kernel.IOUring.Length(1024)
            let c = Kernel.IOUring.Length(2048)
            #expect(a == b)
            #expect(a != c)
        }

        @Test("Length is Hashable")
        func isHashable() {
            var set = Set<Kernel.IOUring.Length>()
            set.insert(.zero)
            set.insert(Kernel.IOUring.Length(1024))
            set.insert(.zero)  // duplicate
            #expect(set.count == 2)
        }

        @Test("Length is Comparable")
        func isComparable() {
            let small = Kernel.IOUring.Length(100)
            let large = Kernel.IOUring.Length(1000)
            #expect(small < large)
            #expect(large > small)
        }

        @Test("Length is RawRepresentable")
        func isRawRepresentable() {
            let length = Kernel.IOUring.Length(rawValue: 512)
            #expect(length.rawValue == 512)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IOUring.Length.Test.EdgeCase {
        @Test("Length clamps large Int values")
        func clampsLargeValues() {
            let length = Kernel.IOUring.Length(Int(UInt32.max) + 1000)
            #expect(length.rawValue == UInt32.max)
        }

        @Test("Length max value")
        func maxValue() {
            let length = Kernel.IOUring.Length(rawValue: UInt32.max)
            #expect(length.rawValue == UInt32.max)
        }

        @Test("Length zero comparison")
        func zeroComparison() {
            let zero = Kernel.IOUring.Length.zero
            let nonZero = Kernel.IOUring.Length(1)
            #expect(zero < nonZero)
        }

        @Test("Length ordering")
        func ordering() {
            let lengths = [
                Kernel.IOUring.Length(100),
                Kernel.IOUring.Length(50),
                Kernel.IOUring.Length(200),
            ]
            let sorted = lengths.sorted()
            #expect(sorted[0].rawValue == 50)
            #expect(sorted[1].rawValue == 100)
            #expect(sorted[2].rawValue == 200)
        }
    }
#endif

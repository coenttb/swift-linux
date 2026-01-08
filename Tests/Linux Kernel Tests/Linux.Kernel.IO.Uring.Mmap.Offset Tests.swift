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

    extension Kernel.IO.Uring.Mmap.Offset {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Mmap.Offset.Test.Unit {
        @Test("Mmap.Offset namespace exists")
        func namespaceExists() {
            _ = Kernel.IO.Uring.Mmap.Offset.self
        }

        @Test("Mmap.Offset is an enum")
        func isEnum() {
            let _: Kernel.IO.Uring.Mmap.Offset.Type = Kernel.IO.Uring.Mmap.Offset.self
        }
    }

    // MARK: - Constant Tests

    extension Kernel.IO.Uring.Mmap.Offset.Test.Unit {
        @Test("sqRing has value 0")
        func sqRingValue() {
            #expect(Kernel.IO.Uring.Mmap.Offset.sqRing == 0)
        }

        @Test("cqRing has value 0x8000000")
        func cqRingValue() {
            #expect(Kernel.IO.Uring.Mmap.Offset.cqRing == 0x8000000)
        }

        @Test("sqes has value 0x10000000")
        func sqesValue() {
            #expect(Kernel.IO.Uring.Mmap.Offset.sqes == 0x1000_0000)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IO.Uring.Mmap.Offset.Test.EdgeCase {
        @Test("offsets are distinct")
        func offsetsDistinct() {
            let offsets: [Int64] = [
                Kernel.IO.Uring.Mmap.Offset.sqRing,
                Kernel.IO.Uring.Mmap.Offset.cqRing,
                Kernel.IO.Uring.Mmap.Offset.sqes,
            ]

            for i in 0..<offsets.count {
                for j in (i + 1)..<offsets.count {
                    #expect(offsets[i] != offsets[j])
                }
            }
        }

        @Test("offsets are page-aligned")
        func offsetsPageAligned() {
            // cqRing and sqes should be page-aligned (multiple of common page sizes)
            #expect(Kernel.IO.Uring.Mmap.Offset.cqRing % 4096 == 0)
            #expect(Kernel.IO.Uring.Mmap.Offset.sqes % 4096 == 0)
        }

        @Test("sqRing is zero")
        func sqRingIsZero() {
            #expect(Kernel.IO.Uring.Mmap.Offset.sqRing == 0)
        }
    }
#endif

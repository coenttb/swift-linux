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


    extension Kernel.IOUring.MmapOffset {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.MmapOffset.Test.Unit {
        @Test("MmapOffset namespace exists")
        func namespaceExists() {
            _ = Kernel.IOUring.MmapOffset.self
        }

        @Test("MmapOffset is an enum")
        func isEnum() {
            let _: Kernel.IOUring.MmapOffset.Type = Kernel.IOUring.MmapOffset.self
        }
    }

    // MARK: - Constant Tests

    extension Kernel.IOUring.MmapOffset.Test.Unit {
        @Test("sqRing has value 0")
        func sqRingValue() {
            #expect(Kernel.IOUring.MmapOffset.sqRing == 0)
        }

        @Test("cqRing has value 0x8000000")
        func cqRingValue() {
            #expect(Kernel.IOUring.MmapOffset.cqRing == 0x8000000)
        }

        @Test("sqes has value 0x10000000")
        func sqesValue() {
            #expect(Kernel.IOUring.MmapOffset.sqes == 0x1000_0000)
        }
    }

    // MARK: - Edge Cases

    extension Kernel.IOUring.MmapOffset.Test.EdgeCase {
        @Test("offsets are distinct")
        func offsetsDistinct() {
            let offsets: [Int64] = [
                Kernel.IOUring.MmapOffset.sqRing,
                Kernel.IOUring.MmapOffset.cqRing,
                Kernel.IOUring.MmapOffset.sqes,
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
            #expect(Kernel.IOUring.MmapOffset.cqRing % 4096 == 0)
            #expect(Kernel.IOUring.MmapOffset.sqes % 4096 == 0)
        }

        @Test("sqRing is zero")
        func sqRingIsZero() {
            #expect(Kernel.IOUring.MmapOffset.sqRing == 0)
        }
    }
#endif

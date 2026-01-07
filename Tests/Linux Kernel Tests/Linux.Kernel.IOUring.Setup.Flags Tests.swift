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


    extension Kernel.IOUring.Setup.Flags {
        #TestSuites
    }

    // MARK: - Type Unit Tests

    extension Kernel.IOUring.Setup.Flags.Test.Unit {

        @Test("flags combine with union")
        func flagsCombineWithUnion() {
            let combined = Kernel.IOUring.Setup.Flags.ioPoll.union(.sqPoll)
            #expect(combined.contains(.ioPoll))
            #expect(combined.contains(.sqPoll))
            #expect(!combined.contains(.sqAff))
        }

        @Test("empty flags is empty")
        func emptyFlagsIsEmpty() {
            let flags: Kernel.IOUring.Setup.Flags = []
            #expect(flags.isEmpty)
            #expect(flags.rawValue == 0)
        }

        @Test("ioPoll has rawValue 1")
        func ioPollHasRawValue1() {
            #expect(Kernel.IOUring.Setup.Flags.ioPoll.rawValue == 1)
        }

        @Test("sqPoll has rawValue 2")
        func sqPollHasRawValue2() {
            #expect(Kernel.IOUring.Setup.Flags.sqPoll.rawValue == 2)
        }

        @Test("flags are distinct")
        func flagsAreDistinct() {
            #expect(Kernel.IOUring.Setup.Flags.ioPoll != .sqPoll)
            #expect(Kernel.IOUring.Setup.Flags.sqPoll != .sqAff)
            #expect(Kernel.IOUring.Setup.Flags.sqAff != .cqSize)
        }
    }

#endif

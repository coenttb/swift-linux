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

    extension Kernel.Event.Poll.Events {
        #TestSuites
    }

    // MARK: - Bridging Unit Tests

    extension Kernel.Event.Poll.Events.Test.Unit {

        @Test("in and out events are distinct")
        func inAndOutAreDistinct() {
            #expect(Kernel.Event.Poll.Events.in != .out)
            #expect(Kernel.Event.Poll.Events.in.rawValue != Kernel.Event.Poll.Events.out.rawValue)
        }

        @Test("events combine with OR operator")
        func eventsCombineWithOrOperator() {
            let combined: Kernel.Event.Poll.Events = [.in, .out]
            #expect(combined.contains(.in))
            #expect(combined.contains(.out))
            #expect(!combined.contains(.err))
        }

        @Test("contains detects single event")
        func containsDetectsSingleEvent() {
            let events: Kernel.Event.Poll.Events = .in
            #expect(events.contains(.in))
            #expect(!events.contains(.out))
        }

        @Test("in event has non-zero rawValue")
        func inRawValueNonZero() {
            #expect(Kernel.Event.Poll.Events.in.rawValue != 0)
        }

        @Test("out event has non-zero rawValue")
        func outRawValueNonZero() {
            #expect(Kernel.Event.Poll.Events.out.rawValue != 0)
        }

        @Test("in and out have different rawValues")
        func inAndOutDifferentRawValues() {
            #expect(Kernel.Event.Poll.Events.in.rawValue != Kernel.Event.Poll.Events.out.rawValue)
        }
    }

#endif

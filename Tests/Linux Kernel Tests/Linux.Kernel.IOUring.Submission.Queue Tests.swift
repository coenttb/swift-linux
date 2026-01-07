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


    extension Kernel.IOUring.Submission.Queue {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Submission.Queue.Test.Unit {
        @Test("Queue namespace exists")
        func namespaceExists() {
            _ = Kernel.IOUring.Submission.Queue.self
        }

        @Test("Queue is an enum")
        func isEnum() {
            let _: Kernel.IOUring.Submission.Queue.Type = Kernel.IOUring.Submission.Queue.self
        }
    }

    // MARK: - Nested Types

    extension Kernel.IOUring.Submission.Queue.Test.Unit {
        @Test("Queue.Entry type exists")
        func entryTypeExists() {
            let _: Kernel.IOUring.Submission.Queue.Entry.Type = Kernel.IOUring.Submission.Queue.Entry.self
        }

        @Test("Queue.Offsets type exists")
        func offsetsTypeExists() {
            let _: Kernel.IOUring.Submission.Queue.Offsets.Type = Kernel.IOUring.Submission.Queue.Offsets.self
        }
    }
#endif

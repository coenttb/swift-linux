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
    import Kernel_Primitives

    extension Kernel.IOUring.Submission {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Submission.Test.Unit {
        @Test("Submission namespace exists")
        func namespaceExists() {
            _ = Kernel.IOUring.Submission.self
        }

        @Test("Submission is an enum")
        func isEnum() {
            let _: Kernel.IOUring.Submission.Type = Kernel.IOUring.Submission.self
        }
    }

    // MARK: - Nested Types

    extension Kernel.IOUring.Submission.Test.Unit {
        @Test("Submission.Queue type exists")
        func queueTypeExists() {
            let _: Kernel.IOUring.Submission.Queue.Type = Kernel.IOUring.Submission.Queue.self
        }
    }
#endif

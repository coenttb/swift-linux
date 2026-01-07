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


    extension Kernel.IOUring.Completion {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Completion.Test.Unit {
        @Test("Completion namespace exists")
        func namespaceExists() {
            _ = Kernel.IOUring.Completion.self
        }

        @Test("Completion is an enum")
        func isEnum() {
            let _: Kernel.IOUring.Completion.Type = Kernel.IOUring.Completion.self
        }
    }

    // MARK: - Nested Types

    extension Kernel.IOUring.Completion.Test.Unit {
        @Test("Completion.Queue type exists")
        func queueTypeExists() {
            let _: Kernel.IOUring.Completion.Queue.Type = Kernel.IOUring.Completion.Queue.self
        }
    }
#endif

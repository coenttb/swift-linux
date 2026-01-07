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


    extension Kernel.IOUring.Setup {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IOUring.Setup.Test.Unit {
        @Test("Setup namespace exists")
        func namespaceExists() {
            _ = Kernel.IOUring.Setup.self
        }

        @Test("Setup is an enum")
        func isEnum() {
            let _: Kernel.IOUring.Setup.Type = Kernel.IOUring.Setup.self
        }
    }

    // MARK: - Nested Types

    extension Kernel.IOUring.Setup.Test.Unit {
        @Test("Setup.Flags type exists")
        func flagsTypeExists() {
            let _: Kernel.IOUring.Setup.Flags.Type = Kernel.IOUring.Setup.Flags.self
        }
    }
#endif

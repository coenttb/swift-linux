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

    extension Kernel.IO.Uring.Setup {
        #TestSuites
    }

    // MARK: - Unit Tests

    extension Kernel.IO.Uring.Setup.Test.Unit {
        @Test("Setup namespace exists")
        func namespaceExists() {
            _ = Kernel.IO.Uring.Setup.self
        }

        @Test("Setup is an enum")
        func isEnum() {
            let _: Kernel.IO.Uring.Setup.Type = Kernel.IO.Uring.Setup.self
        }
    }

    // MARK: - Nested Types

    extension Kernel.IO.Uring.Setup.Test.Unit {
        @Test("Setup.Flags type exists")
        func flagsTypeExists() {
            let _: Kernel.IO.Uring.Setup.Flags.Type = Kernel.IO.Uring.Setup.Flags.self
        }
    }
#endif

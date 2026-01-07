// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-linux open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-linux project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Kernel_Primitives
public import Linux_Primitives
public import POSIX_Kernel

/// Re-export Kernel namespace from primitives for use within Linux module.
public typealias Kernel = Kernel_Primitives.Kernel

/// Re-export Linux namespace from Linux_Primitives.
public typealias Linux = Linux_Primitives.Linux

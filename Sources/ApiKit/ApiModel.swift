//
//  ApiModel.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2024-10-04.
//  Copyright © 2024-2025 Daniel Saidi. All rights reserved.
//

/// This protocol can be implemented by API-specific models.
///
/// This protocol makes all API models conform to both `Codable` and `Sendable`.
public protocol ApiModel: Codable, Sendable {}

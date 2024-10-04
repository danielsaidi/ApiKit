//
//  ApiModel.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2024-10-04.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

/// This protocol can be implemented by API-specific models.
///
/// This protocol makes a type conform to both `Codable` and
/// `Sendable`, which simplifies conforming to both when you
/// create your API models.
public protocol ApiModel: Codable, Sendable {}

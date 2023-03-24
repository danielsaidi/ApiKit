//
//  ApiEnvironment.swift
//  SwiftKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol represents an API environment with a specific
 root `url`, e.g. test, staging or production.
 */
public protocol ApiEnvironment {
    
    var url: URL { get }
}

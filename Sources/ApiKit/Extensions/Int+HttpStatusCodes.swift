//
//  Int+HttpStatusCodes.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2024-10-04.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

extension Int {

    /// HTTP status codes are within the 100-599 range.
    var isValidHttpStatusCode: Bool {
        self > 99 && self < 600
    }

    /// HTTP status codes are only successful within the 200 range.
    var isSuccessfulHttpStatusCode: Bool {
        self > 199 && self < 300
    }

    /// HTTP status codes are only successful within the 200 range.
    var isUnsuccessfulHttpStatusCode: Bool {
        isValidHttpStatusCode && !isSuccessfulHttpStatusCode
    }
}

//
//  String+UrlEncode.swift
//  ApiKit
//
//  Created by Daniel Saidi on 2023-03-24.
//  Copyright © 2023 Daniel Saidi. All rights reserved.
//
//  https://danielsaidi.com/blog/2020/06/04/string-urlencode
//

import Foundation

extension String {

    /**
     Encode the string to work with `x-www-form-urlencoded`.

     This will first call `urlEncoded()`, then replace every
     `+` with `%2B`.
     */
    func formEncoded() -> String? {
        self.urlEncoded()?
            .replacingOccurrences(of: "+", with: "%2B")
    }
    
    /**
     Encode the string to work with quary parameters.
     
     This will first call `addingPercentEncoding`, using the
     `.urlPathAllowed` character set, then replace every `&`
     with `%26`.
     */
    func urlEncoded() -> String? {
        self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)?
            .replacingOccurrences(of: "&", with: "%26")
    }
}

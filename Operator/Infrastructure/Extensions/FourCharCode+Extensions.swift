//
//  FourCharCode+Extensions.swift
//  Operator
//
//  Created by Brian Michel on 5/20/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

// https://gist.github.com/patrickjuchli/d1b07f97e0ea1da5db09
extension FourCharCode {
    public init(stringLiteral value: StringLiteralType) {
        var code: FourCharCode = 0
        // Value has to consist of 4 printable ASCII characters, e.g. '420v'.
        // Note: This implementation does not enforce printable range (32-126)
        if value.count == 4, value.utf8.count == 4 {
            for byte in value.utf8 {
                code = code << 8 + FourCharCode(byte)
            }
        } else {
            Log.warn("FourCharCode: Can't initialize with '\(value)', only printable ASCII allowed. Setting to '????'.")
            code = 0x3F3F_3F3F // = '????'
        }
        self = code
    }
}

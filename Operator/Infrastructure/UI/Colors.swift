//
//  Colors.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI
import UIKit

enum Colors {
    static let op1Gray = UIColor(hex: "D1D4DE")!
    static let op1Blue = UIColor(hex: "76B8EC")!
    static let op1Green = UIColor(hex: "3BCA7A")!
    static let op1White = UIColor(hex: "FDFAFC")!
    static let op1Orange = UIColor(hex: "F0633F")!
}

extension UIColor {
    func asColor() -> Color {
        return Color(self)
    }
}

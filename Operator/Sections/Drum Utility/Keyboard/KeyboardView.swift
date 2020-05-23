//
//  KeyboardView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct KeyPress {
    let section: Int
    let key: Int
    let direction: KeyPressDirection
}

struct KeyLayoutConfiguration {
    let wholeKeys: Int
    let halfKeys: Int
}

enum KeyPressDirection {
    case down
    case up

    var description: String {
        switch self {
        case .down:
            return "down"
        case .up:
            return "up"
        }
    }
}

struct KeyboardView: View {
    private let defaultLayout: [KeyLayoutConfiguration] = [.fullSection, .shortSection, .fullSection, .shortSection]

    let didPressKey: ((KeyPress) -> Void)?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                Spacer().frame(width: 10)
                ForEach(0 ..< self.defaultLayout.count) { index in
                    KeyboardSectionView(section: index, configuration: self.defaultLayout[index], action: self.didPressKey)
                }
                Spacer().frame(width: 10)
            }
        }
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView(didPressKey: nil)
    }
}

extension KeyLayoutConfiguration {
    static let fullSection = KeyLayoutConfiguration(wholeKeys: 4, halfKeys: 3)
    static let shortSection = KeyLayoutConfiguration(wholeKeys: 3, halfKeys: 2)
}

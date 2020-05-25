//
//  KeyboardView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct MappedKeyPress {
    let mappedKeyIndex: Int
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
    private let defaultKeyMap = [[0, 1, 2, 3, 4, 5, 6], [8, 9, 10, 11, 12], [13, 14, 15, 16, 17, 18, 19], [20, 21, 22, 23, 24]]

    let didPressKey: ((MappedKeyPress) -> Void)?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                Spacer().frame(width: 10)
                ForEach(0 ..< self.defaultLayout.count) { index in
                    KeyboardSectionView(section: index, configuration: self.defaultLayout[index], action: { press in
                        let mappedSection = self.defaultKeyMap[press.section]
                        let mappedKey = mappedSection[press.key]
                        self.didPressKey?(MappedKeyPress(mappedKeyIndex: mappedKey, direction: press.direction))
                    })
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

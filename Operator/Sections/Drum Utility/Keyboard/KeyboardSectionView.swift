//
//  KeyboardSectionView.swift
//  Operator
//
//  Created by Brian Michel on 5/23/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct RawKeyPress {
    let section: Int
    let key: Int
    let direction: KeyPressDirection
}

struct KeyboardSectionView: View {
    let section: Int
    let configuration: KeyLayoutConfiguration

    var action: ((RawKeyPress) -> Void)?

    var body: some View {
        GeometryReader { reader in
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    ForEach(0 ..< self.configuration.halfKeys) { index in
                        Button(action: {
                            self.action?(RawKeyPress(
                                section: self.section,
                                key: self.halfKeyAdjustedIndex(for: index),
                                direction: .up
                            ))
                        }, label: {
                            Text("").frame(width: reader.size.width / CGFloat(self.configuration.halfKeys),
                                           height: 20)
                        }).buttonStyle(KeyboardHalfKeyButtonStyle(position: self.position(for: index,
                                                                                          in: self.configuration.halfKeys)))
                            .modifier(TouchDownViewModifier(action: {
                                self.action?(RawKeyPress(section: self.section,
                                                         key: self.halfKeyAdjustedIndex(for: index),
                                                         direction: .down))
                                Haptics().emit(style: .soft)
                            }))
                    }
                }
                HStack(spacing: 2) {
                    ForEach(0 ..< self.configuration.wholeKeys) { index in
                        Button(action: {
                            self.action?(RawKeyPress(
                                section: self.section,
                                key: self.wholeKeyAdjustedIndex(for: index),
                                direction: .up
                            ))
                        }, label: {
                            Text("").frame(width: reader.size.width / CGFloat(self.configuration.wholeKeys),
                                           height: 200)
                        }).buttonStyle(KeyboardWholeKeyButtonStyle()).modifier(TouchDownViewModifier(action: {
                            self.action?(RawKeyPress(section: self.section,
                                                     key: self.wholeKeyAdjustedIndex(for: index),
                                                     direction: .down))
                            Haptics().emit(style: .soft)
                        }))
                    }
                }
            }
        }.frame(width: CGFloat(self.configuration.wholeKeys) * CGFloat(87)).clipped()
    }

    private func position(for index: Int, in count: Int) -> KeyboardHalfKeyButtonStyle.HalfKeyPosition {
        if index == 0 {
            return KeyboardHalfKeyButtonStyle.HalfKeyPosition.first
        } else if (index + 1) == count {
            return KeyboardHalfKeyButtonStyle.HalfKeyPosition.last
        }

        return KeyboardHalfKeyButtonStyle.HalfKeyPosition.middle
    }

    private func wholeKeyAdjustedIndex(for index: Int) -> Int {
        switch index {
        case 0:
            return 0
        case 1:
            return 2
        default:
            return index * 2
        }
    }

    private func halfKeyAdjustedIndex(for index: Int) -> Int {
        let adjustedIndex = index + 1

        switch index {
        case 0:
            return adjustedIndex
        case 1:
            return adjustedIndex + 1
        default:
            return adjustedIndex + 2
        }
    }
}

struct KeyboardSectionView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardSectionView(section: 0, configuration: KeyLayoutConfiguration.fullSection).padding()
    }
}

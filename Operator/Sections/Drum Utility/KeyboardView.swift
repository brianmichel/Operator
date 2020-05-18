//
//  KeyboardView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct KeyboardView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                Spacer().frame(width: 10)
                KeyboardSectionView()
                KeyboardSectionView(wholeKeyCount: 3, halfKeyCount: 2)
                KeyboardSectionView()
                KeyboardSectionView(wholeKeyCount: 3, halfKeyCount: 2)
                Spacer().frame(width: 10)
            }
        }
    }
}

struct KeyboardSectionView: View {
    var wholeKeyCount: Int = 4
    var halfKeyCount: Int = 3

    var body: some View {
        GeometryReader { reader in
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    ForEach(0 ..< self.halfKeyCount) { index in
                        Button(action: {}, label: {
                            Text("").frame(width: reader.size.width / CGFloat(self.halfKeyCount),
                                           height: 20)
                        }).buttonStyle(KeyboardHalfKeyButtonStyle(position: self.position(for: index, in: self.halfKeyCount)))
                    }
                }
                HStack(spacing: 2) {
                    ForEach(0 ..< self.wholeKeyCount) { _ in
                        Button(action: {}, label: {
                            Text("").frame(width: reader.size.width / CGFloat(self.wholeKeyCount),
                                           height: 200)
                        }).buttonStyle(KeyboardWholeKeyButtonStyle())
                    }
                }
            }
        }.frame(width: CGFloat(self.wholeKeyCount) * CGFloat(87))
    }

    private func position(for index: Int, in count: Int) -> KeyboardHalfKeyButtonStyle.HalfKeyPosition {
        if index == 0 {
            return KeyboardHalfKeyButtonStyle.HalfKeyPosition.first
        } else if (index + 1) == count {
            return KeyboardHalfKeyButtonStyle.HalfKeyPosition.last
        }

        return KeyboardHalfKeyButtonStyle.HalfKeyPosition.middle
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KeyboardView()
            KeyboardSectionView().frame(height: 100).padding()
        }
    }
}

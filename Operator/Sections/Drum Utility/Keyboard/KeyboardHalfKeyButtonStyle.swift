//
//  KeyboardHalfKeyButtonStyle.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct TouchDownViewModifier: ViewModifier {
    @State private var touchDown = false

    var action: (() -> Void)?

    func body(content: Content) -> some View {
        let drag = DragGesture(minimumDistance: 0).onChanged { _ in
            if !self.touchDown {
                self.touchDown = true
                self.action?()
            }
        }.onEnded { _ in
            self.touchDown = false
        }

        return content.gesture(drag)
    }
}

struct KeyboardHalfKeyButtonStyle: ButtonStyle {
    enum HalfKeyPosition {
        case first
        case middle
        case last
    }

    let backgroundColor: Color = Colors.op1Gray.asColor()
    var foregroundColor: Color = .white

    var position: HalfKeyPosition = .middle

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(configuration.isPressed ? self.backgroundColor.opacity(0.8) : self.backgroundColor)

                    VStack(alignment: .leading) {
                        Circle().inset(by: 5).fill(Color.black).offset(self.offsetFor(position: self.position))
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .foregroundColor(foregroundColor).font(.system(size: 20, weight: .medium, design: .default))
            .animation(.spring())
    }

    private func offsetFor(position: HalfKeyPosition) -> CGSize {
        switch position {
        case .first:
            return CGSize(width: 20, height: 0)
        case .middle:
            return CGSize.zero
        case .last:
            return CGSize(width: -20, height: 0)
        }
    }
}

struct KeyboardHalfKeyButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button(action: {}, label: {
                Text("")
            }).buttonStyle(KeyboardHalfKeyButtonStyle(position: .first))
            Button(action: {}, label: {
                Text("")
            }).buttonStyle(KeyboardHalfKeyButtonStyle(position: .middle))
            Button(action: {}, label: {
                Text("")
            }).buttonStyle(KeyboardHalfKeyButtonStyle(position: .last))
        }
    }
}

//
//  NeumorphicButtonStyle.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct NeumorphicButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .white, radius: configuration.isPressed ? 7 : 10, x: configuration.isPressed ? -5 : -15, y: configuration.isPressed ? -5 : -15)
                        .shadow(color: .black, radius: configuration.isPressed ? 7 : 10, x: configuration.isPressed ? 5 : 15, y: configuration.isPressed ? 5 : 15)
                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(backgroundColor)
                }
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .foregroundColor(.primary)
            .animation(.spring())
    }
}

struct NeumorphicButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            Text("Hi, I'm a button")
        }).buttonStyle(NeumorphicButtonStyle(backgroundColor: .red))
    }
}

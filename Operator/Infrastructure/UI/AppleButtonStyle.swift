//
//  AppleButtonStyle.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct AppleButtonStyle: ButtonStyle {
    var backgroundColor: Color = Color(Colors.op1Blue)
    var foregroundColor: Color = .white

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(configuration.isPressed ? backgroundColor.opacity(0.8) : backgroundColor)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .foregroundColor(foregroundColor).font(.system(size: 20, weight: .medium, design: .default))
            .animation(.spring())
    }
}

struct AppleButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            Text("Hi, I'm a button")
        }).buttonStyle(AppleButtonStyle(backgroundColor: .red))
    }
}

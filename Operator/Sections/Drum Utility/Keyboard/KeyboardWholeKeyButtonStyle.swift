//
//  KeyboardWholeKeyButtonStyle.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct KeyboardWholeKeyButtonStyle: ButtonStyle {
    let backgroundColor: Color = Colors.op1Gray.asColor()
    var foregroundColor: Color = .white

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .rotationEffect(.degrees(-90))
            .background(
                GeometryReader { reader in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(configuration.isPressed ? self.backgroundColor.opacity(0.8) : self.backgroundColor)

                        RoundedRectangle(cornerRadius: reader.size.width / 2, style: .continuous).fill(self.backgroundColor.opacity(0.9))
                            .frame(
                                width: reader.size.width * 0.60,
                                height: reader.size.height * 0.70
                            ).blendMode(.colorBurn)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .foregroundColor(foregroundColor).font(.system(size: 20, weight: .medium, design: .default))
            .animation(.spring())
    }
}

struct KeyboardWholeKeyButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button(action: {}, label: {
                Text("").frame(height: 200)
            }).buttonStyle(KeyboardWholeKeyButtonStyle())
            Button(action: {}, label: {
                Text("").frame(height: 200)
            }).buttonStyle(KeyboardWholeKeyButtonStyle())
            Button(action: {}, label: {
                Text("").frame(height: 200)
            }).buttonStyle(KeyboardWholeKeyButtonStyle())
        }.background(Color.black)
    }
}

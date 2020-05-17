//
//  KnobView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct KnobView: View {
    private enum Constants {
        static let knobInsetCornerRadius: CGFloat = 0.4
        static let knobInsetWidthMultiplier: CGFloat = 0.2
        static let knobInsetHeightMultiplier: CGFloat = 0.5
    }

    var backgroundColor: Color = Color(Colors.op1Blue)

    var body: some View {
        GeometryReader { reader in
            ZStack {
                Circle().foregroundColor(Color(Colors.op1Gray)).overlay(Circle().stroke(Color.gray, lineWidth: 0.5)).frame(width: reader.size.width, height: reader.size.width)
                Circle().foregroundColor(self.backgroundColor).frame(
                    width: reader.size.width * 0.7,
                    height: reader.size.width * 0.7,
                    alignment: .center
                ).overlay(Circle().stroke(Color(Colors.op1Gray), lineWidth: 0.5))
                RoundedRectangle(cornerRadius: (reader.size.width * Constants.knobInsetCornerRadius) / 2, style: .continuous)
                    .foregroundColor(self.backgroundColor)
                    .frame(
                        width: reader.size.width * Constants.knobInsetWidthMultiplier,
                        height: reader.size.width * Constants.knobInsetHeightMultiplier
                    ).overlay(RoundedRectangle(cornerRadius: reader.size.width * Constants.knobInsetCornerRadius, style: .continuous)
                        .foregroundColor(self.backgroundColor.opacity(0.8))
                        .overlay(RoundedRectangle(
                            cornerRadius: (reader.size.width * Constants.knobInsetCornerRadius) / 2,
                            style: .continuous
                        )
                        .stroke(Color.black.opacity(0.3), lineWidth: 1)))

                RoundedRectangle(cornerRadius: (reader.size.width * Constants.knobInsetCornerRadius) / 2, style: .continuous).foregroundColor(self.backgroundColor).frame(
                    width: reader.size.width * Constants.knobInsetWidthMultiplier * 0.90,
                    height: reader.size.width * Constants.knobInsetHeightMultiplier * 0.95
                )
            }
        }.frame(maxWidth: 100, maxHeight: 100)
    }
}

struct KnobView_Previews: PreviewProvider {
    static var previews: some View {
        KnobView()
    }
}

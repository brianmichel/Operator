//
//  DrumUtilityLoadView.swift
//  Operator
//
//  Created by Brian Michel on 5/25/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct DrumUtilityLoadView: View {
    var action: (() -> Void)?

    var body: some View {
        VStack {
            VStack(spacing: 5) {
                Spacer()
                Text("Drag an AIFF file into here or tap the button below to load a sample").multilineTextAlignment(.center)
                Button(action: {
                    self.action?()
                }, label: {
                    Text("Load sample...")
                }).buttonStyle(AppleButtonStyle(backgroundColor: Colors.op1Green.asColor()))
                Spacer()
            }.padding()
        }.overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(style:
            StrokeStyle(lineWidth: 3,
                        lineCap: .round,
                        dash: [12])).foregroundColor(Color.primary)
        )
    }
}

struct DrumUtilityLoadView_Previews: PreviewProvider {
    static var previews: some View {
        DrumUtilityLoadView().padding()
    }
}

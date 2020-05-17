//
//  KnobsView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct KnobsView: View {
    private let animation = Animation.linear(duration: 3).repeatForever(autoreverses: false)

    @State var animating: Bool = false

    var body: some View {
        HStack {
            KnobView(backgroundColor: Color(Colors.op1Blue)).rotationEffect(.degrees(self.animating ? 360 : 0)).animation(self.animation.delay(0.4))
            KnobView(backgroundColor: Color(Colors.op1Green)).rotationEffect(.degrees(self.animating ? 360 : 0)).animation(self.animation.delay(0.5))
            KnobView(backgroundColor: Color(Colors.op1White)).rotationEffect(.degrees(self.animating ? 360 : 0)).animation(self.animation.delay(0.2))
            KnobView(backgroundColor: Color(Colors.op1Orange)).rotationEffect(.degrees(self.animating ? 360 : 0)).animation(self.animation.delay(0.34))
        }.padding().onAppear {
            self.startAnimating()
        }
    }

    func stopAnimating() {
        animating = false
    }

    func startAnimating() {
        animating = true
    }
}

struct KnobsView_Previews: PreviewProvider {
    static var previews: some View {
        KnobsView()
    }
}

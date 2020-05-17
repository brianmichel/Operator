//
//  DrumUtilityView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct DrumUtilityView: View {
    var body: some View {
        VStack {
            Text("Hello World")
            Spacer()
            KeyboardView().frame(height: 320)
        }.navigationBarTitle("Drum Utility")
    }
}

struct DrumUtilityView_Previews: PreviewProvider {
    static var previews: some View {
        DrumUtilityView()
    }
}

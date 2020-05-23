//
//  DrumUtilityView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct DrumUtilityView: View {
    @ObservedObject var viewModel = DrumUtilityViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            DrumUtilityWaveView(viewModel: viewModel.waveViewModel)
            KeyboardView { action in
                self.viewModel.didPressKey(action: action)
            }.frame(height: 320)
        }.navigationBarTitle("Drum Utility")
    }
}

struct DrumUtilityView_Previews: PreviewProvider {
    static var previews: some View {
        DrumUtilityView()
    }
}

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
    @State private var showFilePicker = false

    var body: some View {
        VStack(spacing: 0) {
            if self.viewModel.selectedAudioFile != nil {
                Spacer()
                DrumUtilityWaveView(viewModel: viewModel.waveViewModel)
                KeyboardView { action in
                    self.viewModel.didPressKey(action: action)
                }.frame(height: 320)
            } else {
                DrumUtilityLoadView {
                    self.showFilePicker.toggle()
                    #if targetEnvironment(macCatalyst)
                        self.showMacDialog(for: self.viewModel.sampleFilePicker)
                    #endif
                }.padding()
            }
        }.navigationBarTitle("Drum Utility").sheet(isPresented: $showFilePicker, content: {
            #if os(iOS)
                self.viewModel.sampleFilePicker
            #endif
        })
    }

    private func showMacDialog(for picker: DocumentPicker, animated: Bool = true) {
        #if targetEnvironment(macCatalyst)
            UIApplication.shared.windows[0].rootViewController?.present(picker.viewController, animated: animated)
        #endif
    }
}

struct DrumUtilityView_Previews: PreviewProvider {
    static var previews: some View {
        DrumUtilityView()
    }
}

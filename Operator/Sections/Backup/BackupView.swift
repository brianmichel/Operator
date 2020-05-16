//
//  BackupView.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct BackupView: View {
    @ObservedObject private var viewModel = BackupViewModel()
    @State var showDocumentPicker = false

    var body: some View {
        VStack {
            Button(action: {
                self.showDocumentPicker.toggle()
                self.viewModel.pickFilePath()
                #if targetEnvironment(macCatalyst)
                    self.showMacDialog(for: self.viewModel.inputPicker)
                #endif
            }, label: {
                Text("Choose Directory")
            }).sheet(isPresented: $showDocumentPicker, content: {
                #if os(iOS)
                    self.viewModel.inputPicker
                #endif
            })
        }
    }

    private func showMacDialog(for picker: DocumentPicker, animated: Bool = true) {
        #if targetEnvironment(macCatalyst)
            UIApplication.shared.windows[0].rootViewController?.present(picker.viewController, animated: animated)
        #endif
    }
}

struct BackupView_Previews: PreviewProvider {
    static var previews: some View {
        BackupView()
    }
}

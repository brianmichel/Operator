//
//  BackupView.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct BackupView: View {
    @ObservedObject var viewModel = BackupViewModel()
    @State var showDocumentPicker = false

    var body: some View {
        VStack {
            Button(action: {
                self.viewModel.pickFilePath()
                self.showDocumentPicker.toggle()
                #if targetEnvironment(macCatalyst)
                    UIApplication.shared.windows[0].rootViewController?.present(self.viewModel.picker.viewController, animated: true)
                #endif
            }) {
                Text("Choose Directory")
            }.sheet(isPresented: $showDocumentPicker, content: {
                #if os(iOS)
                    self.viewModel.picker
                #endif
            })
        }
    }
}

struct BackupView_Previews: PreviewProvider {
    static var previews: some View {
        BackupView()
    }
}

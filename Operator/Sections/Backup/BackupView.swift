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
    #if targetEnvironment(macCatalyst)
        let viewPadding: Edge.Set = [.leading, .trailing, .bottom]
    #else
        let viewPadding: Edge.Set = [.leading, .trailing]
    #endif

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Backup & Restore lets you make copies of your on device file structure and keep them in a safe place. We all mistakenly copy tracks, or lose pieces of work that we really wanted to keep, so backing up often makes it easier to ensure we can keep all of our work from any issues.")
                BulletedVStack(items: [
                    "Make sure your device is turned on and in disk mode.",
                    "Completed backups can be browsed in the Files application.",
                    "Be sure to check Operator's settings menu for compression options.",
                ], font: Font.system(size: 20, weight: .bold, design: .default), bulletColor: Color(Colors.op1Blue), spacing: 15).padding(.top, 20)
                Spacer()
                Button(action: {
                    self.showDocumentPicker.toggle()
                    self.viewModel.pickFilePath()
                    #if targetEnvironment(macCatalyst)
                        self.showMacDialog(for: self.viewModel.inputPicker)
                    #endif
                }, label: {
                    Text("Choose folder".localized(comment: "Button label for asking the user to pick which folder to backup."))
                }).buttonStyle(AppleButtonStyle()).sheet(isPresented: $showDocumentPicker, content: {
                    #if os(iOS)
                        self.viewModel.inputPicker
                    #endif
                })
            }
        }.padding(viewPadding).navigationBarTitle("Backup & Restore")
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

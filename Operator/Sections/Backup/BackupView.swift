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
            VStack(alignment: .center, spacing: 15) {
                Text("Backup & Restore lets you make copies of your on device file structure and keep them in a safe place. We all mistakenly copy tracks, or lose pieces of work that we really wanted to keep, so backing up often makes it easier to ensure we can keep all of our work from any issues."
                    .localized(comment: "Heading text shown to users when they open up Backup & Restore screen."))
                BulletedVStack(items: [
                    "Make sure your device is turned on and in disk mode."
                        .localized(comment: "The first step to ensure users can back up."),
                    "Completed backups can be browsed in the Files application."
                        .localized(comment: "The second step to ensure users can back up."),
                    "Be sure to check Operator's settings menu for compression options."
                        .localized(comment: "The third step to ensure users can back up."),
                ], font: Font.system(size: 20, weight: .bold, design: .default), bulletColor: Color(Colors.op1Blue), spacing: 15).padding(.top, 20)
                if isBackingUp() {
                    VStack {
                        Spacer()
                        BackupInProgressView()
                    }
                }
                Spacer()
                Button(action: {
                    self.showDocumentPicker.toggle()
                    self.viewModel.pickFilePath()
                    #if targetEnvironment(macCatalyst)
                        self.showMacDialog(for: self.viewModel.inputPicker)
                    #endif
                }, label: {
                    Text("Choose folder".localized(comment: "Button label for asking the user to pick which folder to backup."))
                }).buttonStyle(AppleButtonStyle()).disabled(isBackingUp())
                    .sheet(isPresented: $showDocumentPicker, content: {
                        #if os(iOS)
                            self.viewModel.inputPicker
                        #endif
                    })
            }
        }.padding(viewPadding).navigationBarTitle("Backup & Restore".localized(comment: "Navigation title for Backup & Restore screen.")).alert(isPresented: $viewModel.backupCompleted) {
            Alert(title: Text("Backup Completed"),
                  message: Text("Your backup is complete, would you like to view the file?"),
                  primaryButton: .default(Text("View".localized(comment: "Label for button to show user the backed up file.")), action: {
                      if let url = self.viewModel.destinationURL?.enclosingFolderURL() {
                          UIApplication.shared.open(url)
                      }
                  }),
                  secondaryButton: .cancel(Text("Dismiss".localized(comment: "Label for button to dismiss the back up completion confirmation."))))
        }
    }

    private func isBackingUp() -> Bool {
        switch viewModel.state {
        case .backingUp:
            return true
        default:
            return false
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

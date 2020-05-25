//
//  DrumUtilityLoadSampleView.swift
//  Operator
//
//  Created by Brian Michel on 5/25/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct DrumUtilityLoadSampleView: View {
    @State private var dropZoneActive = false

    var tappedButton: (() -> Void)?
    var droppedFile: ((URL) -> Void)?

    var body: some View {
        let delegate = LoadSampleDropDelegate(dropZoneActive: self.$dropZoneActive, droppedFile: self.droppedFile)

        return VStack {
            VStack(spacing: 5) {
                Spacer()
                Text("Drag an AIFF file into here or tap the button below to load a sample").multilineTextAlignment(.center)
                Button(action: {
                    self.tappedButton?()
                }, label: {
                    Text("Load sample...")
                }).buttonStyle(AppleButtonStyle(backgroundColor: Colors.op1Green.asColor()))
                Spacer()
            }.padding()
        }.overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(style:
            StrokeStyle(lineWidth: 3,
                        lineCap: .round,
                        dash: [12])).foregroundColor(Color.primary)
        ).onDrop(of: ["public.aifc-audio"], delegate: delegate)
    }
}

struct LoadSampleDropDelegate: DropDelegate {
    @Binding var dropZoneActive: Bool

    var droppedFile: ((URL) -> Void)?

    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: ["public.aifc-audio"])
    }

    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: ["public.aifc-audio"]).first {
            item.loadItem(forTypeIdentifier: "public.aifc-audio", options: nil) { url, error in
                guard error == nil, let fileURL = url as? URL else {
                    Log.error("Unable to load item from drag and drop - \(String(describing: error))")
                    return
                }

                DispatchQueue.main.async {
                    self.droppedFile?(fileURL)
                }

                Log.debug("Got URL? - \(fileURL)")
            }
            return true
        }

        return false
    }
}

struct DrumUtilityLoadView_Previews: PreviewProvider {
    static var previews: some View {
        DrumUtilityLoadSampleView().padding()
    }
}

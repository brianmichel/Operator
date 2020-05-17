//
//  BackupInProgressView.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct BackupInProgressView: View {
    var body: some View {
        VStack {
            KnobsView()
            Text("Backing up your device now..."
                .localized(comment: "Shown to users when they are in the middle of backing up their device."))
        }
    }
}

struct BackupInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        BackupInProgressView()
    }
}

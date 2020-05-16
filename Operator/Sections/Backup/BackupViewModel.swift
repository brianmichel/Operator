//
//  BackupViewModel.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation
import UIKit

final class BackupViewModel: ObservableObject {
    @Published private(set) var showDocumentPicker = false
    let picker = DocumentPicker()

    func pickFilePath() {
        showDocumentPicker = true
    }

    func completeFilePicking(url _: URL?) {
        showDocumentPicker = false
    }
}

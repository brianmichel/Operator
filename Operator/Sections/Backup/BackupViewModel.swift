//
//  BackupViewModel.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import Foundation
import UIKit

final class BackupViewModel: ObservableObject {
    @Published var showDocumentPicker = false
    @Published var inputURL: URL?
    @Published var destinationURL: URL?

    let inputPicker = DocumentPicker()
    let destinationPicker = DocumentPicker()

    private var storage = Set<AnyCancellable>()

    init() {
        inputPicker.$selectedURLs.map { (urls) -> URL? in
            urls.first
        }.sink { url in
            if let fileURL = url {
                self.inputURL = fileURL
                self.backupInputSelected(input: fileURL)
            }
        }.store(in: &storage)

        destinationPicker.$selectedURLs.map { (urls) -> URL? in
            urls.first
        }.sink { url in
            if let fileURL = url {
                self.destinationURL = fileURL
            }
        }.store(in: &storage)
    }

    func pickFilePath() {
        showDocumentPicker = true
    }

    func completeFilePicking(url _: URL?) {
        showDocumentPicker = false
    }

    private func backupInputSelected(input: URL) {
        let compressor = FolderCompressor(inputDirectory: input,
                                          outputDirectory: URL(fileURLWithPath: NSTemporaryDirectory()))
        let compressedURL = compressor.compress()
    }
}

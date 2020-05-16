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
    var showDocumentPicker = false
    var inputURL: URL?

    var destinationURL: URL?
    var destinationURLAvailable: Bool = false

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

        compressor.compress()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    Log.error("There was an error compressing your backup: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { compressedURL in
                self.destinationURL = compressedURL
                self.destinationURLAvailable = true
                Log.debug("Successfully compressed and moved backup to - \(compressedURL)")
            }).store(in: &storage)
    }
}

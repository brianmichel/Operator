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

enum BackupViewModelState {
    case waitingForUserSelection
    case backingUp
    case backingUpError(error: Error)
    case backingUpCompleted(url: URL)
}

final class BackupViewModel: ObservableObject {
    @Published private(set) var state: BackupViewModelState = .waitingForUserSelection

    @Published var showDocumentPicker = false
    var inputURL: URL?

    @Published var backupCompleted = false
    var destinationURL: URL?

    let inputPicker = DocumentPicker(allowedDocumentTypes: ["public.folder"])
    let destinationPicker = DocumentPicker(allowedDocumentTypes: ["public.folder"])

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

        state = .backingUp
        backupCompleted = false
        compressor.compress()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    Log.error("There was an error compressing your backup: \(error)")
                    self.state = .backingUpError(error: error)
                case .finished:
                    break
                }
            }, receiveValue: { compressedURL in
                self.destinationURL = compressedURL
                Log.debug("Successfully compressed and moved backup to - \(compressedURL)")
                self.state = .backingUpCompleted(url: compressedURL)
                self.backupCompleted = true
            }).store(in: &storage)
    }
}

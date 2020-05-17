//
//  FolderCompressor.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import Compression
import ZIPFoundation

struct FolderCompressorError: Error {
    let message: String
}

enum CompressionError: Error {
    case unableToFindParameters
    case compressionFailed(error: Error)
    case unableToMoveArchive
}

final class FolderCompressor {
    private let inputDirectory: URL
    private let outputFileName: String

    private let algorithm: Algorithm

    private let queue = DispatchQueue(label: "me.foureyes.Operator.folder-compressor")

    lazy var destinationPath: URL = {
        URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(outputFileName).zip")
    }()

    lazy var compressedArchivePath: URL = {
        URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(outputFileName).zip\(algorithm.rawValue.pathExtension)")
    }()

    init(inputDirectory: URL,
         outputDirectory _: URL,
         outputFileName: String = "OPBackup-\(Date())",
         algorithm: Algorithm = .zlib) {
        self.inputDirectory = inputDirectory
        self.outputFileName = outputFileName
        self.algorithm = algorithm
    }

    func compress() -> Future<URL, CompressionError> {
        let future = Future<URL, CompressionError> { [weak self] promise in
            guard let strongSelf = self,
                let queue = self?.queue,
                let inputDirectory = self?.inputDirectory,
                let destinationPath = self?.destinationPath,
                let outputFileName = self?.outputFileName,
                let compressedArchivePath = self?.compressedArchivePath,
                let algorithm = self?.algorithm else {
                promise(.failure(.unableToFindParameters))
                return
            }
            queue.async {
                do {
                    Log.debug("Attempting to begin archive creation...\nInput: \(inputDirectory.absoluteString)\nDestination: \(destinationPath.absoluteString)")
                    try strongSelf.createArchive(from: inputDirectory, to: destinationPath)
                    Log.debug("Successfully created zip archive into temporary folder \(destinationPath)")
                    try strongSelf.compressArchive(from: destinationPath, to: compressedArchivePath)

                    Log.debug("Trying to move archive into place...")
                    let archiveURL = try strongSelf.moveArchiveToDocuments(from: compressedArchivePath, fileName: "\(outputFileName)\(algorithm.rawValue.pathExtension)")
                    promise(.success(archiveURL))
                } catch {
                    Log.error("There was an error attempting to compress archive: \(error)")
                    promise(.failure(.compressionFailed(error: error)))
                }
            }
        }

        return future
    }

    private func moveArchiveToDocuments(from: URL, fileName _: String) throws -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]

        let docURL = URL(fileURLWithPath: documentsDirectory)
        let toFileURL = docURL.appendingPathComponent(outputFileName)

        let fileManager = FileManager()

        try fileManager.moveItem(at: from, to: toFileURL)

        return toFileURL
    }

    private func createArchive(from directory: URL, to location: URL) throws {
        guard directory.startAccessingSecurityScopedResource() else {
            throw FolderCompressorError(message: "Unable to acquire security scope access to directory \(directory)")
        }
        defer { directory.stopAccessingSecurityScopedResource() }

        var error: NSError?
        NSFileCoordinator().coordinate(readingItemAt: directory, options: .resolvesSymbolicLink, error: &error) { url in
            do {
                let manager = FileManager()
                try manager.zipItem(at: url, to: location, shouldKeepParent: false)
            } catch let zipError {
                Log.error("Error trying to zip \(url) - \(zipError)")
            }
        }
    }

    private func compressArchive(from archive: URL, to compressedArchive: URL) throws {
        let sourceHandle = try FileHandle(forReadingFrom: archive)

        let created = FileManager.default.createFile(atPath: compressedArchive.path,
                                                     contents: nil,
                                                     attributes: nil)

        let destinationHandle = try FileHandle(forWritingTo: compressedArchive)

        if created {
            try Compressor.streamingCompression(operation: COMPRESSION_STREAM_ENCODE,
                                                sourceFileHandle: sourceHandle,
                                                destinationFileHandle: destinationHandle,
                                                algorithm: algorithm.rawValue) { updatedProgress in
                Log.debug("Progress compressing file \(archive) - \(updatedProgress)")
            }
        } else {
            Log.error("Unable to create compressed file at '\(compressedArchive.path)'")
        }
    }
}

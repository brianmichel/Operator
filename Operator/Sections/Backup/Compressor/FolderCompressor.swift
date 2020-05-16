//
//  FolderCompressor.swift
//  Operator
//
//  Created by Brian Michel on 5/16/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Compression
import Foundation
import ZIPFoundation

final class FolderCompressor {
    private let inputDirectory: URL
    private let outputFileName: String

    private let algorithm: Algorithm

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

    func compress() -> URL? {
        do {
            Log.debug("Attempting to begin archive creation..\nInput: \(inputDirectory.absoluteString)\nDestination: \(destinationPath.absoluteString)")
            try createArchive(from: inputDirectory, to: destinationPath)
            try compressArchive(from: destinationPath, to: compressedArchivePath)

            return compressedArchivePath
        } catch {
            Log.error("There was an error attempting to compress archive: \(error)")
        }

        return nil
    }

    private func createArchive(from directory: URL, to location: URL) throws {
        let manager = FileManager()
        try manager.zipItem(at: directory, to: location, shouldKeepParent: false)
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

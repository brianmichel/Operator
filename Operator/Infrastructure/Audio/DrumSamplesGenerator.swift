//
//  DrumSamplesGenerator.swift
//  Operator
//
//  Created by Brian Michel on 5/23/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import AudioToolbox
import Foundation

final class DrumSamplesGenerator {
    let file: AudioFile

    init(file: AudioFile) {
        self.file = file
    }

    func generate() -> [DrumSample] {
        if let metadata = file.userData,
            let header = DrumHeaderMetadata(rawHeader: metadata) {
            // This has an OP-1 Header, process it as a full drumkit.

            let samples = header.markers.map { (marker) -> DrumSample in
                DrumSample(length: marker.end - marker.start,
                           playMode: .loop,
                           audioNode: file.createAudioSourceNode(startTime: marker.start, endTime: marker.end))
            }

            return samples
        } else {
            // No OP-1 Header, we should slice it automatically.
        }

        return []
    }
}

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
    private enum Constants {
        static let defaultSampleCount = 24
    }

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
                           audioPlayer: file.createAudioPlayerForSlice(at: marker.start, to: marker.end),
                           marker: marker)
            }

            return samples
        } else {
            // No OP-1 Header, we should slice it automatically.
            let duration = file.duration
            let sampleDuration = Double(duration / Float64(Constants.defaultSampleCount))

            let samples = (0 ..< Constants.defaultSampleCount).map { (slice) -> DrumSample in
                let start = Double(slice) * sampleDuration
                let end = start + sampleDuration
                let pair: MarkerPair = (start: start, end: end)
                return DrumSample(length: pair.end - pair.start,
                                  playMode: .oneShot,
                                  audioPlayer: file.createAudioPlayerForSlice(at: start, to: end),
                                  marker: pair)
            }

            return samples
        }
    }
}

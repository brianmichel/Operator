//
//  DrumUtilityViewModel.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import Foundation

final class DrumUtilityWaveViewModel: ObservableObject {
    @Published var markers = [SampleMarker]()
    @Published var showRelativeSlicing = false
}

struct SampleMarker: Identifiable {
    var id = UUID()
    let start: Double
    let end: Double
}

final class DrumUtilityViewModel: ObservableObject {
    @Published private(set) var selectedAudioFile: AudioFile?
    @Published private(set) var waveViewModel = DrumUtilityWaveViewModel()

    init() {
        attemptToLoad(audioFile: Bundle.main.url(forResource: "sample-adjusted", withExtension: ".aif")!)
    }

    private func attemptToLoad(audioFile url: URL) {
        guard let file = AudioFile(url: url),
            let rawMetadata = file.userData,
            let metadata = DrumHeaderMetadata(rawHeader: rawMetadata),
            file.duration > 0 else {
            Log.error("Unable to open audio file at URL - \(url)")
            return
        }

        let duration = Double(file.duration)
        let relativeStartMarkers = metadata.markers.map { (pair) -> SampleMarker in
            if pair.start == 0 {
                return SampleMarker(start: 0, end: pair.end / duration)
            }

            Log.debug("Start - \(pair.start), Duration - \(duration)")
            return SampleMarker(start: pair.start / duration, end: pair.end / duration)
        }

        waveViewModel.markers = relativeStartMarkers
        Log.debug("Generated relative markers - \(relativeStartMarkers)")
    }
}

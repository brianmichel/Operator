//
//  DrumUtilityViewModel.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import AVFoundation
import Combine
import Foundation

struct SampleMarker: Identifiable {
    var id = UUID()
    let start: Double
    let end: Double
}

final class DrumUtilityViewModel: ObservableObject {
    @Published private(set) var selectedAudioFile: AudioFile?
    @Published private(set) var waveViewModel = DrumUtilityWaveViewModel()

    let sampleFilePicker = DocumentPicker(allowedDocumentTypes: ["public.aiff-audio", "public.aifc-audio"])

    private var storage = Set<AnyCancellable>()

    init() {
        sampleFilePicker.$selectedURLs.map { (urls) -> URL? in
            urls.first
        }.sink { url in
            if let fileURL = url {
                self.attemptToLoad(audioFile: fileURL)
            }
        }.store(in: &storage)
    }

    func didPressKey(action: KeyPress) {
        Log.debug("Did press \(action.direction) in section: \(action.section) at key \(action.key)")
        switch action.direction {
        case .down:
            // TODO: un-hardcode on touch up to play the first sample
            waveViewModel.playSample(at: action.key)
        case .up:
            waveViewModel.stopSample(at: action.key)
        }
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

            return SampleMarker(start: pair.start / duration, end: pair.end / duration)
        }

        waveViewModel.markers = relativeStartMarkers

        let generator = DrumSamplesGenerator(file: file)
        waveViewModel.samples = generator.generate()

        selectedAudioFile = file
    }
}

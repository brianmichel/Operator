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

    let sampleFilePicker = DocumentPicker(allowedDocumentTypes: ["public.aifc-audio"])

    private var storage = Set<AnyCancellable>()

    private let workQueue = DispatchQueue(label: "me.foureyes.Operator.drum-utility-work-queue")

    init() {
        sampleFilePicker.$selectedURLs.map { (urls) -> URL? in
            urls.first
        }.sink { url in
            if let fileURL = url {
                self.attemptToLoad(audioFile: fileURL)
            }
        }.store(in: &storage)
    }

    func reset() {
        selectedAudioFile = nil
        waveViewModel.reset()
    }

    func didPressKey(action: MappedKeyPress) {
        switch action.direction {
        case .down:
            // TODO: un-hardcode on touch up to play the first sample
            waveViewModel.playSample(at: action.mappedKeyIndex)
        case .up:
            waveViewModel.stopSample(at: action.mappedKeyIndex)
        }
    }

    func attemptToLoad(audioFile url: URL) {
        #if targetEnvironment(macCatalyst)
            let canAccessFile = true
        #else
            let canAccessFile = url.startAccessingSecurityScopedResource()
        #endif
        guard canAccessFile,
            let file = AudioFile(url: url),
            file.duration > 0 else {
            Log.error("Unable to open audio file at URL - \(url)")
            return
        }

        workQueue.async { [weak self] in
            #if !targetEnvironment(macCatalyst)
                defer {
                    url.stopAccessingSecurityScopedResource()
                }
            #endif
            let duration = Double(file.duration)
            let generator = DrumSamplesGenerator(file: file)
            let samples = generator.generate()

            let relativeStartMarkers = samples.map { (sample) -> SampleMarker in
                SampleMarker(start: sample.marker.start / duration, end: sample.marker.end / duration)
            }

            // Hop back on the main thread to do setting
            DispatchQueue.main.async {
                self?.waveViewModel.samples = samples
                self?.waveViewModel.markers = relativeStartMarkers
                self?.selectedAudioFile = file
            }
        }
    }
}

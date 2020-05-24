//
//  DrumUtilityViewModel.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import AudioKit
import AVFoundation
import Combine
import Foundation

final class DrumUtilityWaveViewModel: ObservableObject {
    @Published var markers = [SampleMarker]()
    @Published var showRelativeSlicing = false

    var samples = [DrumSample]() {
        willSet {
            samples.forEach { $0.audioPlayer?.detach() }
        }
        didSet {
            samples.forEach { sample in
                if let player = sample.audioPlayer {
                    player >>> audioMixer
                }
            }
        }
    }

    private var audioMixer = AKMixer()

    init() {
        do {
            AKManager.output = audioMixer
            try AKManager.start()
        } catch {
            Log.error("Unable to start AudioKit - \(error)")
        }
    }

    func playSample(at index: Int) {
        let sample = samples[index]

        if let audioPlayer = sample.audioPlayer {
            audioPlayer.play(from: 0)
        }
    }

    func stopSample(at index: Int) {
        let sample = samples[index]

        if sample.playMode == .whileHeld,
            let player = sample.audioPlayer {
            player.pause()
        }
    }

    deinit {
        do {
            try AKManager.stop()
        } catch {
            Log.error("Unable to stop AudioKit - \(error)")
        }
    }
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

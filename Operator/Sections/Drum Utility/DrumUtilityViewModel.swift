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
    private var samples: [DrumSample]?
    @Published private(set) var waveViewModel = DrumUtilityWaveViewModel()

    private var engine = AVAudioEngine()

    init() {
        attemptToLoad(audioFile: Bundle.main.url(forResource: "sample-adjusted", withExtension: ".aif")!)
    }

    func didPressKey(action: KeyPress) {
        Log.debug("Did press \(action.direction) in section: \(action.section) at key \(action.key)")

        if let drumSamples = samples {
            switch action.direction {
            case .up:
                // TODO: un-hardcode on touch up to play the first sample
                connectAndPlay(sample: drumSamples[0])
            case .down:
                disconnectAndStop(sample: drumSamples[0])
            }
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

            Log.debug("Start - \(pair.start), Duration - \(duration)")
            return SampleMarker(start: pair.start / duration, end: pair.end / duration)
        }

        waveViewModel.markers = relativeStartMarkers
        let generator = DrumSamplesGenerator(file: file)
        samples = generator.generate()

        selectedAudioFile = file
    }

    private func createAudioEngine(from _: AudioFile) -> AVAudioEngine {
        let engine = AVAudioEngine()
        let mainMixer = engine.mainMixerNode
        let output = engine.outputNode

        let outputFormat = output.inputFormat(forBus: 0)

        engine.connect(mainMixer, to: output, format: outputFormat)

        return engine
    }

    private func connectAndPlay(sample: DrumSample) {
        let mainMixer = engine.mainMixerNode
        let outputNode = engine.outputNode
        let sourceNode = sample.audioNode.node!

        engine.attach(sourceNode)
        engine.connect(sourceNode, to: mainMixer, format: AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 1, interleaved: false))
        engine.connect(mainMixer, to: outputNode, format: nil)

        engine.mainMixerNode.outputVolume = 0.9

        do {
            try engine.start()
        } catch {
            Log.error("Unable to start engine due to error - \(error)")
        }
    }

    private func disconnectAndStop(sample _: DrumSample) {}
}

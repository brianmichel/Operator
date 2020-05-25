//
//  DrumUtilityWaveViewModel.swift
//  Operator
//
//  Created by Brian Michel on 5/25/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import AudioKit
import Foundation

final class DrumUtilityWaveViewModel: ObservableObject {
    @Published var markers = [SampleMarker]()
    @Published var showRelativeSlicing = false
    @Published var showSamples = false

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
            showSamples = samples.count > 0
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

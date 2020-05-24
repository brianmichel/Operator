//
//  DrumPatch.swift
//  Operator
//
//  Created by Brian Michel on 5/23/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import AudioKit
import AVFoundation
import Foundation

protocol HeaderPackable {
    associatedtype PackableType

    func pack() -> PackableType
}

enum SamplePlayMode: HeaderPackable {
    typealias PackableType = Int

    case oneShot
    case loop
    case whileHeld

    func pack() -> Int {
        switch self {
        case .oneShot:
            return 8192
        case .loop:
            return 16384
        case .whileHeld:
            return 8000
        }
    }
}

struct DrumSample {
    let length: Double
    let playMode: SamplePlayMode
    let audioPlayer: AKAudioPlayer?
}

final class DrumPatch {
    private var samples = [DrumSample]()

    func remove(sampleAt index: Int) {
        samples.remove(at: index)
    }

    func add(sample: DrumSample) {
        samples.append(sample)
    }
}

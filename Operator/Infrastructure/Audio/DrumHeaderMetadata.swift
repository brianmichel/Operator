//
//  DrumHeaderMetadata.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

typealias MarkerPair = (start: Double, end: Double)

final class DrumHeaderMetadata {
    private enum Constants {
        static let sampleRate = 44100.0
        static let magic = 4096.0
        static func fromHeaderFormat(samples: Int) -> Double {
            return Double(samples) / Constants.sampleRate / Constants.magic
        }

        static func toHeaderFormat(seconds: Float) -> Int {
            return Int(Double(seconds) * Constants.sampleRate * Constants.magic)
        }
    }

    let markers: [MarkerPair]

    init?(rawHeader: RawDrumHeaderMetadata) {
        precondition(rawHeader.start.count == rawHeader.end.count)
        markers = zip(rawHeader.start, rawHeader.end).map { (items) -> MarkerPair in
            (start: Constants.fromHeaderFormat(samples: items.0),
             end: Constants.fromHeaderFormat(samples: items.1))
        }
    }
}

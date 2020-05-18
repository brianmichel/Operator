//
//  RawDrumHeaderMetadata.swift
//  Operator
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

final class RawDrumHeaderMetadata: Codable {
    let drumVersion: Int
    let type: String
    let name: String
    let octave: Int
    let start: [Int]
    let end: [Int]
    let playmode: [Int]
    let reverse: [Int]
    let volume: [Int]
    let dynamicEnvelope: [Int]
    let fxActive: Bool
    let fxType: String
    let fxParameters: [Int]
    let lfoActive: Bool
    let lfoType: String
    let lfoParameters: [Int]

    enum CodingKeys: String, CodingKey {
        case drumVersion = "drum_version"
        case type
        case name
        case octave
        case start
        case end
        case playmode
        case reverse
        case volume
        case dynamicEnvelope = "dyna_env"
        case fxActive = "fx_active"
        case fxType = "fx_type"
        case fxParameters = "fx_params"
        case lfoActive = "lfo_active"
        case lfoType = "lfo_type"
        case lfoParameters = "lfo_params"
    }
}

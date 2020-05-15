//
//  OperatorTests.swift
//  OperatorTests
//
//  Created by Brian Michel on 5/4/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import XCTest
import AudioToolbox

extension XCTestCase {
    var testBundle: Bundle {
        return Bundle(for: self.classForCoder)
    }
}

@testable import Operator

class OperatorTests: XCTestCase {
    func testCanReadFileFormat() throws {
        let url = testBundle.url(forResource: "sample-modified", withExtension: ".aif")!
        let file = AudioFile(url: url)!

        let type: AudioFilePropertyID = file.get(property: kAudioFilePropertyFileFormat)!

        XCTAssertEqual(type, kAudioFileAIFFType, "Audio file type should be AIFF since it's the input type.")
        XCTAssertNotEqual(type, kAudioFileCAFType, "Audio file is not a CAF file so should not show up like that.")
    }

    func testValidDataFormat() {
        let url = testBundle.url(forResource: "sample-adjusted", withExtension: ".aif")!
        let file = AudioFile(url: url)!

        guard let description: AudioStreamBasicDescription = file.get(property: kAudioFilePropertyDataFormat) else {
            XCTFail()
            return
        }

        XCTAssertEqual(description.mSampleRate, Float64(Float(44100)))
        XCTAssertEqual(description.mFormatID, kAudioFormatLinearPCM)
    }

    func testContainsAPPLChunk() {
        let url = testBundle.url(forResource: "sample-modified", withExtension: ".aif")!
        let file = AudioFile(url: url)!

        XCTAssertEqual(file.userDataCount, 1, "Should contain exactly 1 APPL chunk")
    }

    func testInfoDictionary() {
        let url = testBundle.url(forResource: "sample-adjusted", withExtension: ".aif")!
        let file = AudioFile(url: url)!

        guard let info: NSDictionary = file.get(property: kAudioFilePropertyInfoDictionary) else {
            XCTFail()
            return
        }

        XCTAssertGreaterThan(info.allKeys.count, 0)
    }
}

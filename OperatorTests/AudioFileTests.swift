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

class AudioFileTests: XCTestCase {
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

        guard let headerData = file.userData else {
            XCTFail("Unable to parse APPL chunk header data.")
            return
        }

        XCTAssertNotNil(headerData, "There should be structured data available in the APPL chunk.")
        XCTAssertEqual(headerData.drumVersion, 1, "Drum version should be 1")
        XCTAssertEqual(headerData.name, "user", "Header should be set to 'user'")
        XCTAssertEqual(headerData.type, "drum", "Type should be set to 'drum'")
        XCTAssertEqual(headerData.start.count, 24, "There should be 25 start points")
        XCTAssertEqual(headerData.end.count, 24, "There should be 25 end points")
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

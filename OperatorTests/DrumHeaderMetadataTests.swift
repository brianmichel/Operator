//
//  DrumHeaderMetadataTests.swift
//  OperatorTests
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import XCTest

@testable import Operator

class DrumHeaderMetadataTests: XCTestCase {
    func testConvertsHeaderFormat() throws {
        let url = testBundle.url(forResource: "sample-modified", withExtension: ".aif")!
        let file = AudioFile(url: url)!

        let rawMetadata = file.userData!

        guard let metadata = DrumHeaderMetadata(rawHeader: rawMetadata) else {
            XCTFail("Unable to create metadata from raw metadata")
            return
        }

        XCTAssertEqual(metadata.markers.count, 24, "There should be 24 markers")
    }

}

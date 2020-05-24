//
//  DrumSamplesGeneratorTests.swift
//  OperatorTests
//
//  Created by Brian Michel on 5/24/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import XCTest

@testable import Operator

class DrumSamplesGeneratorTests: XCTestCase {

    func testGeneratesSamples() {
        let url = testBundle.url(forResource: "sample-modified", withExtension: ".aif")!
        let file = AudioFile(url: url)!

        let generator = DrumSamplesGenerator(file: file)
        let samples = generator.generate()

        XCTAssertEqual(samples.count, 24, "There should be 24 samples generated")
    }

}

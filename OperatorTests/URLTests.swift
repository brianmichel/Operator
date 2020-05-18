//
//  URLTests.swift
//  OperatorTests
//
//  Created by Brian Michel on 5/17/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import XCTest

@testable import Operator

class URLTests: XCTestCase {
    let pathUnderTest = "file:///Users/tester/Library/Developer/CoreSimulator/Containers/Data/Application/Documents/OPBackup-2020-05-17%2019:10:56%20+0000"

    func testRewritingEnclosingURL() throws {
        let url = URL(fileURLWithPath: pathUnderTest)
        let enclosing = url.enclosingFolderURL()
        #if targetEnvironment(macCatalyst)
        let targetValue = "file:/Users/tester/Library/Developer/CoreSimulator/Containers/Data/Application/Documents/"
        XCTAssertTrue(enclosing.absoluteString == targetValue, "The macOS implementation should just remove the last path component")
        #else
        let targetValue = "shareddocuments:///Users/tester/Library/Developer/CoreSimulator/Containers/Data/Application/Documents"
        XCTAssertTrue(enclosing.absoluteString == targetValue, "The iOS implementation should remove the last path component, and add shareddocuments://")
        #endif
    }
}

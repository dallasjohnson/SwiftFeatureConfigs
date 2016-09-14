//
//  FeatureConfigsTests.swift
//  FeatureConfigsTests
//
//  Created by Dallas Johnson on 11/08/2016.
//  Copyright © 2016 Dallas Johnson. All rights reserved.
//

import XCTest
import UIKit
import SwiftFeatureConfigs

class FeatureConfigsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Features.loadInMemoryFeatures([:])
        Features.clearPersistedConfigs()
    }

    override func tearDown() {
        super.tearDown()
        Features.clearInMemoryConfigs()
        Features.clearPersistedConfigs()
    }

    func testBoolFeatureSet() {
        Features.loadInMemoryFeatures(["boolFeature": false])
        let result = Features.boolFeature
        XCTAssertFalse(result)
    }

    func testBoolFeatureUnset() {
        let result = Features.boolFeature
        XCTAssertTrue(result)
    }

    func testStringFeatureSet() {
        Features.loadInMemoryFeatures(["stringFeature": "set message"])

        let result = Features.stringFeature
        XCTAssertEqual(result, "set message")
    }

    func testStringFeatureUnset() {
        let result = Features.stringFeature
        XCTAssertEqual(result, "default message")
    }

    func testIntFeatureSet() {
        Features.loadInMemoryFeatures(["intFeature": 23])

        let result = Features.intFeature
        XCTAssertEqual(result, 23)
    }

    func testIntFeatureUnset() {
        let result = Features.intFeature
        XCTAssertEqual(result, 11)
    }

    func testDoubleFeatureSet() {
        Features.loadInMemoryFeatures(["doubleFeature": 29.5])

        let result = Features.doubleFeature
        XCTAssertEqual(result, 29.5)
    }

    func testDoubleFeatureUnset() {
        let result = Features.doubleFeature
        XCTAssertEqual(result, 113.45)
    }

    func testLoadAndPersist() {
        //Seed and save in NSUserDefaults
        Features.loadInMemoryFeatures(["stringFeature": "set message"])
        Features.persist()

        let result = NSUserDefaults.standardUserDefaults()
            .dictionaryForKey("Features_defaults_key_")!["stringFeature"] as! String

        XCTAssertEqual(result, "set message")
    }

    func testClearLoaded() {
        //precondition
        Features.loadInMemoryFeatures(["stringFeature": "set message"])
        let welcomeMessage = Features.stringFeature
        XCTAssertEqual(welcomeMessage, "set message")

        //Clear the in memory defaults
        Features.clearInMemoryConfigs()

        //Load from the persisted defaults
        let result = Features.stringFeature
        XCTAssertEqual(result, "default message")
    }

    func testClearPersisted() {
        //precondition
        Features.loadInMemoryFeatures(["stringFeature": "set message"])
        Features.persist()
        Features.clearInMemoryConfigs() // Clear loaded because it should pull from the defaults
        let welcomeMessage = Features.stringFeature
        XCTAssertEqual(welcomeMessage, "set message")
    }
}

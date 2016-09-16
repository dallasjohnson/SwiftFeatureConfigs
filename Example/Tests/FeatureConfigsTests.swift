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
    
    var features: Features!

    override func setUp() {
        super.setUp()
        features = Features()
        features.loadInMemoryFeatures([:])
        features.clearPersistedConfigs()
    }

    override func tearDown() {
        super.tearDown()
        features.clearInMemoryConfigs()
        features.clearPersistedConfigs()
    }

    func testBoolFeatureSet() {
        features.loadInMemoryFeatures(["boolFeature": false])
        let result = features.boolFeature
        XCTAssertFalse(result)
    }

    func testBoolFeatureUnset() {
        let result = features.boolFeature
        XCTAssertTrue(result)
    }

    func testStringFeatureSet() {
        features.loadInMemoryFeatures(["stringFeature": "set message"])

        let result = features.stringFeature
        XCTAssertEqual(result, "set message")
    }

    func testStringFeatureUnset() {
        let result = features.stringFeature
        XCTAssertEqual(result, "default message")
    }

    func testIntFeatureSet() {
        features.loadInMemoryFeatures(["intFeature": 23])

        let result = features.intFeature
        XCTAssertEqual(result, 23)
    }

    func testIntFeatureUnset() {
        let result = features.intFeature
        XCTAssertEqual(result, 11)
    }

    func testDoubleFeatureSet() {
        features.loadInMemoryFeatures(["doubleFeature": 29.5])

        let result = features.doubleFeature
        XCTAssertEqual(result, 29.5)
    }

    func testDoubleFeatureUnset() {
        let result = features.doubleFeature
        XCTAssertEqual(result, 113.45)
    }

    func testLoadAndPersist() {
        //Seed and save in NSUserDefaults
        features.loadInMemoryFeatures(["stringFeature": "set message"])
        features.persist()

        let result = NSUserDefaults.standardUserDefaults()
            .dictionaryForKey("Features_defaults_key_")!["stringFeature"] as! String

        XCTAssertEqual(result, "set message")
    }

    func testClearLoaded() {
        //precondition
        features.loadInMemoryFeatures(["stringFeature": "set message"])
        let welcomeMessage = features.stringFeature
        XCTAssertEqual(welcomeMessage, "set message")

        //Clear the in memory defaults
        features.clearInMemoryConfigs()

        //Load from the persisted defaults
        let result = features.stringFeature
        XCTAssertEqual(result, "default message")
    }

    func testClearPersisted() {
        //precondition
        features.loadInMemoryFeatures(["stringFeature": "set message"])
        features.persist()
        features.clearInMemoryConfigs() // Clear loaded because it should pull from the defaults
        let welcomeMessage = features.stringFeature
        XCTAssertEqual(welcomeMessage, "set message")
    }
}

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
    
    var testFeatures: TestFeatures!

    override func setUp() {
        super.setUp()
        testFeatures = TestFeatures()
        testFeatures.loadInMemoryFeatures([:])
        testFeatures.clearPersistedConfigs()
    }

    override func tearDown() {
        super.tearDown()
        testFeatures.clearInMemoryConfigs()
        testFeatures.clearPersistedConfigs()
    }

    func testBoolFeatureSet() {
        testFeatures.loadInMemoryFeatures(["boolFeature": false])
        let result = testFeatures.boolFeature
        XCTAssertFalse(result)
    }

    func testBoolFeatureUnset() {
        let result = testFeatures.boolFeature
        XCTAssertTrue(result)
    }

    func testStringFeatureSet() {
        testFeatures.loadInMemoryFeatures(["stringFeature": "set message"])

        let result = testFeatures.stringFeature
        XCTAssertEqual(result, "set message")
    }

    func testStringFeatureUnset() {
        let result = testFeatures.stringFeature
        XCTAssertEqual(result, "default message")
    }

    func testIntFeatureSet() {
        testFeatures.loadInMemoryFeatures(["intFeature": 23])

        let result = testFeatures.intFeature
        XCTAssertEqual(result, 23)
    }

    func testIntFeatureUnset() {
        let result = testFeatures.intFeature
        XCTAssertEqual(result, 11)
    }

    func testDoubleFeatureSet() {
        testFeatures.loadInMemoryFeatures(["doubleFeature": 29.5])

        let result = testFeatures.doubleFeature
        XCTAssertEqual(result, 29.5)
    }

    func testDoubleFeatureUnset() {
        let result = testFeatures.doubleFeature
        XCTAssertEqual(result, 113.45)
    }

    func testLoadAndPersistForPersistable() {
        //Seed and save in NSUserDefaults
        testFeatures.loadInMemoryFeatures(["stringFeature": "set message", "stringFeaturePreventPersisting": "setNonPersistingMessage"])
        testFeatures.persist()

        let persistedResult = NSUserDefaults.standardUserDefaults().dictionaryForKey("TestFeatures_defaults_key_")!["stringFeature"] as! String
        
        XCTAssertEqual(persistedResult, "set message")
        
        let nonPersistedResult = NSUserDefaults.standardUserDefaults()
            .dictionaryForKey("TestFeatures_defaults_key_")!["stringFeaturePreventPersisting"]
        
        XCTAssertNil(nonPersistedResult)
    }

    func testClearLoaded() {
        //precondition
        testFeatures.loadInMemoryFeatures(["stringFeature": "set message"])
        let welcomeMessage = testFeatures.stringFeature
        XCTAssertEqual(welcomeMessage, "set message")

        //Clear the in memory defaults
        testFeatures.clearInMemoryConfigs()

        //Load from the persisted defaults
        let result = testFeatures.stringFeature
        XCTAssertEqual(result, "default message")
    }

    func testClearPersisted() {
        //precondition
        testFeatures.loadInMemoryFeatures(["stringFeature": "set message"])
        testFeatures.persist()
        testFeatures.clearInMemoryConfigs() // Clear loaded because it should pull from the defaults
        let welcomeMessage = testFeatures.stringFeature
        XCTAssertEqual(welcomeMessage, "set message")
    }
}

//
//  FeatureConfigsTestsWithOverride.swift
//  FeatureConfigsTestsWithOverride
//
//  Created by Dallas Johnson on 11/08/2016.
//  Copyright © 2016 Dallas Johnson. All rights reserved.
//

import XCTest
import SwiftFeatureConfigs


/// These tests are similar to the FeatureConfigTests but this target has a plist file included to enable testing the plist overrides.
class FeatureConfigsTestsWithOverride: XCTestCase {

    var testFeaturesWithOverride: TestFeatures!

    override func setUp() {
        super.setUp()
        let overrideURL = Bundle(for: type(of: self)).url(forResource: "FeaturesOverride", withExtension: "plist")
        self.testFeaturesWithOverride = TestFeatures(featuresLocalFileURL: overrideURL)
        
        let otherURL = Bundle(for: type(of: self)).url(forResource: "FeaturesOverride", withExtension: "plist")
        _ = OtherTestFeatures(featuresLocalFileURL: otherURL)
        
        testFeaturesWithOverride.loadInMemoryFeatures(["someOtherFeature" : 123])
        testFeaturesWithOverride.clearPersistedConfigs()
    }

    override func tearDown() {
        super.tearDown()
        testFeaturesWithOverride.clearInMemoryConfigs()
        testFeaturesWithOverride.clearPersistedConfigs()
    }

    func testBoolFeatureSet() {
        let result = testFeaturesWithOverride.boolFeature
        XCTAssertTrue(result)
    }

    func testStringFeatureSet() {
        let result = testFeaturesWithOverride.stringFeature
        XCTAssertEqual(result, "kjshdkjhsdf")
    }

    func testIntFeatureSet() {
        let result = testFeaturesWithOverride.intFeature
        XCTAssertEqual(result, 456)
    }

    func testDoubleFeatureSet() {
        let result = testFeaturesWithOverride.doubleFeature
        XCTAssertEqual(result, 987.45)
    }

    func testFeatureInMemoryWithoutOverride() {
        let result = testFeaturesWithOverride.someOtherFeature
        XCTAssertEqual(result, 123)
    }
}

extension TestFeatures {
     var someOtherFeature: Int {
        return config(defaultValue: 4567)
    }
}

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

    var features: Features!

    override func setUp() {
        super.setUp()
        let overrideURL = Bundle(for: type(of: self)).url(forResource: "FeaturesOverride", withExtension: "plist")
        self.features = Features(featuresLocalFileURL: overrideURL)
        features.loadInMemoryFeatures(["someOtherFeature" : 123 as AnyObject])
        features.clearPersistedConfigs()
    }

    override func tearDown() {
        super.tearDown()
        features.clearInMemoryConfigs()
        features.clearPersistedConfigs()
    }

    func testBoolFeatureSet() {
        let result = features.boolFeature
        XCTAssertTrue(result)
    }

    func testStringFeatureSet() {
        let result = features.stringFeature
        XCTAssertEqual(result, "kjshdkjhsdf")
    }

    func testIntFeatureSet() {
        let result = features.intFeature
        XCTAssertEqual(result, 456)
    }

    func testDoubleFeatureSet() {
        let result = features.doubleFeature
        XCTAssertEqual(result, 987.45)
    }

    func testFeatureInMemoryWithoutOverride() {
        let result = features.someOtherFeature
        XCTAssertEqual(result, 123)
    }
}

extension Features {
     var someOtherFeature: Int {
        return setting(defaultValue: 4567)
    }
}

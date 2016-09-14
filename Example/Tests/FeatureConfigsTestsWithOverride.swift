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

    override static func setUp() {
        super.setUp()
        Features.overrideFileURL = NSBundle(forClass: self).URLForResource("FeaturesOverride", withExtension: "plist")
    }

    override func setUp() {
        super.setUp()
        Features.loadInMemoryFeatures(["someOtherFeature" : 123])
        Features.clearPersistedConfigs()
    }

    override func tearDown() {
        super.tearDown()
        Features.clearInMemoryConfigs()
        Features.clearPersistedConfigs()
    }

    func testBoolFeatureSet() {
        let result = Features.boolFeature
        XCTAssertTrue(result)
    }

    func testStringFeatureSet() {
        let result = Features.stringFeature
        XCTAssertEqual(result, "kjshdkjhsdf")
    }

    func testIntFeatureSet() {
        let result = Features.intFeature
        XCTAssertEqual(result, 456)
    }

    func testDoubleFeatureSet() {
        let result = Features.doubleFeature
        XCTAssertEqual(result, 987.45)
    }

    func testFeatureInMemoryWithoutOverride() {
        let result = Features.someOtherFeature
        XCTAssertEqual(result, 123)
    }

    func testNestedFeatures() {
        SubFeature.loadInMemoryFeatures(["nestedBoolFeature": true])
        SubFeature.persist()
        let result = Features.subFeature.boolFeature
        XCTAssertTrue(result)
    }
}

extension Features {
    static var someOtherFeature: Int {
        return setting(defaultValue: 4567)
    }
}

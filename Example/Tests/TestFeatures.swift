//
//  TestFeatures.swift
//  Features
//
//  Created by Dallas Johnson on 11/08/2016.
//  Copyright © 2016 Dallas Johnson. All rights reserved.
//

import Foundation
import SwiftFeatureConfigs

class OtherTestFeatures: SwiftFeatureConfigs {
}

class TestFeatures: SwiftFeatureConfigs {

     @objc var boolFeature: Bool {
        return config(defaultValue: true)
    }

    @objc var stringFeature: String {
        return config(defaultValue: "default message")
    }

     @objc var intFeature: Int {
        return config(defaultValue: 11)
    }

     @objc var doubleFeature: Double {
        return config(defaultValue: 113.45)
    }

    @objc var stringFeaturePreventPersisting: String {
        return config(defaultValue: "default message should not persisted")
    }
}


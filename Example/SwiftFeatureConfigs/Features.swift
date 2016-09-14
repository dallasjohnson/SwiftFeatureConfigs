//
//  Features.swift
//  Features
//
//  Created by Dallas Johnson on 11/08/2016.
//  Copyright © 2016 Dallas Johnson. All rights reserved.
//

import Foundation
import SwiftFeatureConfigs

class Features: SwiftFeatureConfigs {

    static var boolFeature: Bool {
        return setting(defaultValue: true)
    }

    static var stringFeature: String {
        return setting(defaultValue: "default message")
    }

    static var intFeature: Int {
        return setting(defaultValue: 11)
    }

    static var doubleFeature: Double {
        return setting(defaultValue: 113.45)
    }

    static var subFeature: SubFeature.Type {
        return SubFeature.self
    }
}

class SubFeature: SwiftFeatureConfigs {

    static var boolFeature: Bool {
        return setting(defaultValue: true)
    }

}

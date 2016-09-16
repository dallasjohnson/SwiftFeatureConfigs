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

     var boolFeature: Bool {
        return setting(defaultValue: true)
    }

     var stringFeature: String {
        return setting(defaultValue: "default message")
    }

     var intFeature: Int {
        return setting(defaultValue: 11)
    }

     var doubleFeature: Double {
        return setting(defaultValue: 113.45)
    }
}

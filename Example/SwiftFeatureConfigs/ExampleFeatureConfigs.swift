//
//  ExampleFeatureConfigs.swift
//  SwiftFeatureConfigs
//
//  Created by Dallas Johnson on 19/09/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import SwiftFeatureConfigs

class ExampleFeatureConfigs: SwiftFeatureConfigs {
    
    static var sharedInstance: ExampleFeatureConfigs = ExampleFeatureConfigs()
    
    
    var detailsViewEnabled: Bool {
        return config(defaultValue: true)
    }
    
    var numberOfCellsToDisplay: Int {
        return config(defaultValue: 12)
    }
    
    var mainViewTitle: String {
        return config(defaultValue: "SampleTitle")
    }
    
}

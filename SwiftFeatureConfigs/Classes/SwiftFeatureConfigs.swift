//
//  SwiftFeatureConfigs.swift
//  FeatureConfigs
//
//  Created by Dallas Johnson on 23/08/2016.
//  Copyright © 2016 Dallas Johnson. All rights reserved.
//

import Foundation

public protocol FeatureConfigValueType {}

extension String: FeatureConfigValueType {}
extension Int: FeatureConfigValueType {}
extension Double: FeatureConfigValueType {}
extension Float: FeatureConfigValueType {}
extension Bool: FeatureConfigValueType {}
extension NSDate: FeatureConfigValueType {}
extension NSData: FeatureConfigValueType {}

public typealias ConfigsValueCollection = [String: Any]
fileprivate typealias ConfigsCollection = [String: ConfigCollectableType]

extension URL {
    fileprivate var toConfigs: ConfigsValueCollection? {
        return NSDictionary(contentsOf: self) as? ConfigsValueCollection
    }
}

//This is required because the FeatureConfig generics and cannot be added to a collection with a generic type.
protocol ConfigCollectableType {
    var key: String { get }
}

/// A Simple struct to hold a config including a key to access it's value, default value and whether it should be persisted.
struct FeatureConfig<T>: ConfigCollectableType {
    let key: String
    let defaultValue: T
}

open class SwiftFeatureConfigs: NSObject {

/// URL for the local PList file to override the settings. (for QA or developer)
    fileprivate static var featuresConfigsLocalPlistFileURL: URL?

    fileprivate var configsCollection = ConfigsCollection()

/// Overriden configs as loaded from a local Plist file using the supplied URL if supplied in the init or the default based on the "className.plist" or returns and empty dictionary.
    lazy fileprivate var overrideFeatureConfigs: ConfigsValueCollection = {
        return featuresConfigsLocalPlistFileURL?.toConfigs ??
        Bundle.main.url(forResource: "\((type(of: self)))", withExtension: "plist")?.toConfigs ??
        [:]
    }()

/// In memory configs as loaded at runtime from server or other source
    fileprivate var inMemoryFeatureConfigs: ConfigsValueCollection?

    public init(featuresLocalFileURL: URL? = nil) {
        type(of: self).featuresConfigsLocalPlistFileURL = featuresLocalFileURL
        super.init()
    }

    /**
     Generic method to set up a feature config. This ensures type safety with a default value and key derived from the name of the enclosing var/method. This class should be overriden with features added like in the example below.
     
     ````
     
     var someRandomFeature: Bool {
     return config(defaultValue: false)
     }
     ````
     
     - parameter key:          string used as a key in the override configs, in memory configs and user defaults persisted configs.
     - parameter defaultValue: default value if the override, in memory or persisted features do not contain a valid value for the given key.

     - returns: the found value
     
     The value returned will be retrieved from sources in the following order:
     
     1. Overriden feature configs as loaded from a plist named "Features.plist" in the current bundle.
     2. In memory configs as loaded by `loadInMemoryFeatures()`
     3. The default value for the given config
     */
    public func config<T>(_ key: String = #function, defaultValue: T) -> T {
        let config: FeatureConfig<T>
        if let foundConfig = configsCollection[key] as? FeatureConfig<T> {
            config = foundConfig
        } else {
            let lazilyCreatedConfig = FeatureConfig(key: key, defaultValue: defaultValue)
            configsCollection[key] = lazilyCreatedConfig
            config = lazilyCreatedConfig
        }
        return getValue(config: config)
    }

    fileprivate func getValue<T>(config: FeatureConfig<T>) -> T {
        let key = config.key
        return overrideFeatureConfigs[key] as? T ??
            inMemoryFeatureConfigs?[key] as? T ??
            config.defaultValue
    }

    // MARK: - Utility Methods
    /**
     Loads a dictionary of feature configs into memory. This would be used to inject configs based on app or user configs retrieved from a network call.
     Pass in a JSON object such as:
     
          { 
          "MySpecialFeatureIsEnabled": true,
          "usernameValidationRegex": "[a-zA-Z.]{2,}@[a-zA-Z.]{2,}"
          }
and they will mapped feature configs with the same keys
     - parameter rawConfigs: dictionary of features
     */
    public func loadInMemoryFeatures(_ configs: ConfigsValueCollection) {
          inMemoryFeatureConfigs = configs
    }
    
    /**
     Clears the loaded in memory configs
     */
    public func clearInMemoryConfigs() {
        inMemoryFeatureConfigs = nil
    }
 }

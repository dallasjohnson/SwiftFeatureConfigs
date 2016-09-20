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
    var persistableOnDevice: Bool { get }
}

struct FeatureConfig<T>: ConfigCollectableType {
    let f = Array<Int>()
    let key: String
    let defaultValue: T
    let persistableOnDevice: Bool
}

open class SwiftFeatureConfigs: NSObject {
    
    fileprivate var defaultsKey: String {
        return "\(type(of: self))_defaults_key_"
    }
    
    fileprivate static var featuresLocalFileURL: URL?
    
    fileprivate var configsCollection = ConfigsCollection()
    
    lazy fileprivate var overrideFeatureConfigs: ConfigsValueCollection = {
        let localOverrideFeatures = featuresLocalFileURL?.toConfigs
        let defaultOverrideFeatures = Bundle.main.url(forResource: "\((type(of: self)))", withExtension: "plist")?.toConfigs
        return localOverrideFeatures ?? defaultOverrideFeatures ?? [:]
    }()
    
    fileprivate var inMemoryFeatureConfigs: ConfigsValueCollection?
    fileprivate var persistedFeatureConfigs: ConfigsValueCollection? {
        return UserDefaults.standard.dictionary(forKey: self.defaultsKey) 
    }
    
    public init(featuresLocalFileURL: URL? = nil) {
        type(of: self).featuresLocalFileURL = featuresLocalFileURL
        super.init()
    }
    
    /**
     Generic method to set up a feature config. This ensures type safety with a default value and key derived from the name of the enclosing var/method. This class should be overriden with features added like in the example below.
     
     ````
     
     var someRandomFeature: Bool {
     return config(defaultValue: false, persistableOnDevice: false)
     }
     
     ````
     
     - parameter key:          string used as a key in the override configs, in memory configs and user defaults persisted configs.
     - parameter defaultValue: default value if the override, in memory or persisted features do not contain a valid value for the given key.
     - parameter persistableOnDevice: To prevent a config from being persisted onto the device this parameter should be set to false. This is useful for a feature that should always be fetched from the network and should fall back to the config's default rather than the last inMemory configs that were persisted.
     
     - returns: the found value
     
     The value returned will be retrieved from sources in the following order:
     
     1. Overriden feature configs as loaded from a plist named "Features.plist" in the current bundle.
     2. In memory configs as loaded by `loadInMemoryFeatures()`
     3. Persisted configs saved in the NSUserDefaults under key derived from the current class "'ClassName'__defaults_key_.key"
     4. The default value for the given config
     */
    open func config<T>(_ key: String = #function, defaultValue: T, persistableOnDevice: Bool = true) -> T {
        let config: FeatureConfig<T>
        if let s = configsCollection[key] as? FeatureConfig<T> {
            config = s
        } else {
            let s = FeatureConfig(key: key,defaultValue: defaultValue, persistableOnDevice: persistableOnDevice)
            configsCollection[key] = s
            config = s
        }
        return getValue(config: config)
    }
    
    fileprivate func getValue<T>(config: FeatureConfig<T>) -> T {
        let key = config.key
        return overrideFeatureConfigs[key] as? T ??
            inMemoryFeatureConfigs?[key] as? T ??
            persistedFeatureConfigs?[key] as? T ??
            config.defaultValue
    }
    
    // MARK: - Utility Methods
    /**
     Loads a dictionary of feature configs into memory. This would be used to load configs based on app or user configs retrieved from a network call.
     - parameter rawConfigs: dictionary of features
     */
    open func loadInMemoryFeatures(_ configs: ConfigsValueCollection) {
        inMemoryFeatureConfigs = configs
    }
    /**
     Clears the loaded in memory configs.
     */
    open func clearInMemoryConfigs() {
        inMemoryFeatureConfigs = nil
    }
    /**
     Persist the in memory feature configs for later offline use. These will be saved in the NSUserDefaults using in a dictionary under the key "'ClassName'_defaults_key_"
     */
    
    open func persist() {
        guard var features = inMemoryFeatureConfigs else { return print("No features loaded yet to persist") }
        
        //seed the configs list based on the currently loaded inMemoryConfigs so the persistable flag can be read.
        for (key,_) in features {
            _ = perform(Selector(key))
        }
        
        for (key, config) in configsCollection where config.persistableOnDevice == false {
            features.removeValue(forKey: key)
        }
        UserDefaults.standard.set(features, forKey: self.defaultsKey)
    }
    /**
     Deletes the persisted configs from the NSUserDefaults
     */
    open func clearPersistedConfigs() {
        UserDefaults.standard.set(nil, forKey: self.defaultsKey)
    }
}

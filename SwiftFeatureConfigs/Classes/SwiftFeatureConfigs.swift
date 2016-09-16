//
//  SwiftFeatureConfigs.swift
//  FeatureConfigs
//
//  Created by Dallas Johnson on 23/08/2016.
//  Copyright © 2016 Dallas Johnson. All rights reserved.
//

import Foundation

public class SwiftFeatureConfigs: NSObject {

    private var defaultsKey: String {
        return "\(self.dynamicType)_defaults_key_"
    }

    public static var featuresLocalFileURL: NSURL?

    private var inMemoryFeatureConfigs: [String: AnyObject]?

    private var overrideFeatureConfigs: [String: AnyObject] = {
        if let url = featuresLocalFileURL, let configs = NSDictionary(contentsOfURL: url) as? [String: AnyObject] {
            return configs
        } else {
            return [:]
        }
    }()

    private var persistedFeatureConfigs: [String: AnyObject]? {
        return NSUserDefaults.standardUserDefaults().dictionaryForKey(self.defaultsKey)
    }

    private func urlToConfigs(url: NSURL?) -> [String: AnyObject]? {
        return url.flatMap { NSDictionary(contentsOfURL: $0) as? [String: AnyObject] }
    }

    public init(featuresLocalFileURL: NSURL? = nil) {
        super.init()
        overrideFeatureConfigs = urlToConfigs(featuresLocalFileURL) ??
            urlToConfigs(NSBundle(forClass:self.dynamicType).URLForResource("Features", withExtension:"plist")) ??
            [:]
    }

    /**
     Generic method to set up a feature config. This ensures type safety with a default value and key derived from the name of the enclosing var/method. The key could be overriden by supplying a custom key parameter. This class should be overriden with features added like in the example below.

     ````

     var someRandomFeature: Bool {
     return setting(defaultValue: false)
     }

     ````

     - parameter key:          string used as a key in the override configs, in memory configs and user defaults persisted configs.
     - parameter defaultValue: default value if the override, in memory or persisted features do not contain a valid value for the given key.

     - returns: the found value

     The value returned will be retrieved from sources in the following order:

     1. Overriden feature configs as loaded from a plist named "Features.plist" in the current bundle.
     2. In memory settings as loaded by `loadInMemoryFeatures()`
     3. Persisted configs saved in the NSUserDefaults under key derived from the current class "'ClassName'__defaults_key_.key"
     4. The default value for the given setting
     */
    public func setting<T>(key: String = #function, defaultValue: T) -> T {
        return overrideFeatureConfigs[key] as? T ??
            inMemoryFeatureConfigs?[key] as? T ??
            persistedFeatureConfigs?[key] as? T ??
        defaultValue
    }

    // MARK: - Utility Methods
    /**
     Loads a dictionary of feature configs into memory. This would be used to load configs based on app or user settings retrieved from a network call.
     - parameter rawConfigs: dictionary of features
     */
    public func loadInMemoryFeatures(configs: [String: AnyObject]) {
        inMemoryFeatureConfigs = configs
    }
    /**
     Clears the loaded in memory configs.
     */
    public func clearInMemoryConfigs() {
        inMemoryFeatureConfigs = nil
    }
    /**
     Persist the in memory feature configs for later offline use. These will be saved in the NSUserDefaults using in a dictionary under the key "'ClassName'_defaults_key_"
     */
    public func persist() {
        guard let features = inMemoryFeatureConfigs else { return print("No features loaded yet to persist") }
        NSUserDefaults.standardUserDefaults().setObject(features, forKey: self.defaultsKey)
    }
    /**
     Deletes the persisted configs from the NSUserDefaults
     */
    public func clearPersistedConfigs() {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: self.defaultsKey)
    }
}

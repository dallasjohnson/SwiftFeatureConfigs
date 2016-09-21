# SwiftFeatureConfigs

[![Build Status](https://travis-ci.org/dallasjohnson/SwiftFeatureConfigs.svg?branch=master)](https://travis-ci.org/dallasjohnson/SwiftFeatureConfigs)
[![Version](https://img.shields.io/cocoapods/v/SwiftFeatureConfigs.svg?style=flat)](http://cocoapods.org/pods/SwiftFeatureConfigs)
[![License](https://img.shields.io/cocoapods/l/SwiftFeatureConfigs.svg?style=flat)](http://cocoapods.org/pods/SwiftFeatureConfigs)
[![Platform](https://img.shields.io/cocoapods/p/SwiftFeatureConfigs.svg?style=flat)](http://cocoapods.org/pods/SwiftFeatureConfigs)

##Introduction
This library provides feature configs/toggles to swift and Objective C projects that is type-safe and configurable for in-production and in-development environments.

This solution was inspired by the pain of dealing with large epic branches that slowly drift further and further from, not only the Master branch, but other epic branches running in parellel that are not yet ready to be merged or shipped. It would be nice to have a robust and reliable way hide features behind a toggle that could be either toggled by a server in production or locally by developers and QA engineers before releases.

Other solutions I have seen require "stringly typed" toggles with server coordination, and then casting to the required type to populate a feature. Typically someone would say "Login as UserX on the UAT server and they have featureY enabled." The toggling would be more brittle than the code it's trying to hide. The aim here was reduce these custom environment dependencies and enable a dev or tester to work on a story with everything more in their control. 

##How it works

  Feature configs are controlled via 4 levels of control listed in the order that will take priority first.
  
1. **Override Feature Configs** via a local plist file stored in the app's Bundle. This would be most appropriate for a developer working on an individual feature in their own app sandbox or for a QA engineer testing a silently deployed feature for possible side effect regression bugs before releasing a feature to the public. The plist file should ***only*** be included in development builds or used by testers. 
  
2. **In Memory Features Configs** These may be configured at app launch time or when a user logs in to provides run time specific features or A/B testing. The in memory settings would be populated with a dictionary detailing the feature configs that should be updated with keys matching the name of the featureConfig `eg. callToActionPurchaseText` These can then be persisted using `persistInMemorySettings()` for future offline use into the UserDefaults.
  
3. **Persisted Feature Configs** using UserDefaults for on device persistant storage. The network will not always be available but your app may have offline features that should still work as they did for the user's last run.
  
4. **Default Setting** Each feature config should have a default value when it is declared. This should have an initial value to ensure that if none of the above have previously been set there is still a sensible default so the app will still behave safely.

##Setup
1. Create a subclass from `SwiftFeatureConfigs`. This is an `NSObject` to enable use with Objective-C codebases as well as Swift. 
2. Declare settings as computed vars in the subclass as below.

```swift
import SwiftFeatureConfigs

class MyFeatureConfigs: SwiftFeatureConfigs {
    
    // Using as a singleton may simplify use thoughout the app...
    // if you don't mind using singletons
    static var sharedInstance: MyFeatureConfigs = MyFeatureConfigs()
    
    var someFeatureEnabled: Bool {
        return config(defaultValue: true, persistableOnDevice: true)
    }
    
    var numberOfItemsToDisplay: Int {
        return config(defaultValue: 12)
    }
    
    var mainViewTitle: String {
        return config(defaultValue: "SampleTitle", persistableOnDevice: false)
    }
}

```

The key function is the `config` function in each var:

```swift
    open func config<T>(_ key: String = #function, defaultValue: T, persistableOnDevice: Bool = true) -> T {
```

From this, a type-safe value will be retrieved as described above.
The key is derived from the containing var/function and is used as the key to search in the **Override Feature Configs** plist, from the **in memory configs** or from the **user defaults**.

By default `SwiftFeatureConfigs` will search for a plist file named after current subclass with ".plist" as an extension. `eg. MyFeatureConfigs.plist` in the main bundle. This can be overriden by supplying another URL to the initialiser for the subclass instance.

```swift
    static var sharedInstance: MyFeatureConfigs = MyFeatureConfigs(customOverrideoURL)
```


The **in memory configs** are loaded with a dictionary from a source of your choice (probably your server as part of a user's login response) and should be simply keyed with the var names:

```swift
let setting = [ "someFeatureEnabled" : true,
				 "numberOfItemsToDisplay" : 15,
				"mainViewTitle": "SomeTitleToDisplay"
				]
```

```swift
 MyFeatureConfigs.sharedInstance.loadInMemoryFeatures(settings)
```

If the configs should be available for future offline use be sure to persist them using:

```swift
 MyFeatureConfigs.sharedInstance.persist()
```
(configs tagged with `persistableOnDevice` as `false` will be excluded from persisting.
 
###Other Stuff

The in memory configs can be cleared using:

```swift
 MyFeatureConfigs.sharedInstance.clearInMemoryConfigs()
```
The persisted configs can be cleared with:

```swift
 MyFeatureConfigs.sharedInstance.clearPersistedConfigs()
```

## Install

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Swift 3+ with Objective-C on iOS.

## Installation

SwiftFeatureConfigs is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftFeatureConfigs"
```

## Author

Dallas Johnson, dallasj001@gmail.com

## License

SwiftFeatureConfigs is available under the MIT license. See the LICENSE file for more info.

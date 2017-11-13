import Foundation

class MyFeatures: SwiftFeatureConfigs { 

  var isaEnabled: Bool {
    return config(key: "isaEnabledKey", defaultValue: false)
  }

  var otherThingEnabled: Bool {
    return config(defaultValue: true)
  }

  var titleString: String {
    return config(key: "titleStringKey", defaultValue: "My Default title")
  }
}

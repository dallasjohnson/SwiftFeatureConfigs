
import Foundation
import SwiftFeatureConfigs

class MyFeatures: SwiftFeatureConfigs {

  static var shared: MyFeatures = MyFeatures()

  ///Set true if ISAs should be visible in the app
  var isaEnabled: Bool {
    return config("isaEnabledKey", defaultValue: false)
  }
  ///Set true if the main navigationBar should be visible
  var navigationBarIsVisible: Bool {
    return config(defaultValue: true)
  }

  var otherThingEnabled101: Bool {
    return config("otherThingEnabledKey102", defaultValue: true)
  }

  var otherThingEnabled2: Bool {
    return config("otherThingEnabledKey2", defaultValue: true)
  }

  var otherThingEnabled3: Bool {
    return config(defaultValue: true)
  }

  var otherThingEnabled4: Bool {
    return config(defaultValue: true)
  }

  var otherThingEnabled5: Bool {
    return config(defaultValue: true)
  }

  var otherThingEnabled6: Bool {
    return config(defaultValue: true)
  }

  var otherThingEnabled7: Bool {
    return config(defaultValue: true)
  }

  var specialFloatValue: Float {
    return config(defaultValue: 12.4)
  }

  var numberOfCellsToDisplaySomeWhere: Int {
    return config(defaultValue: 12)
  }

  var titleString: String {
    return config("titleStringKey", defaultValue: "My Default title")
  }
}

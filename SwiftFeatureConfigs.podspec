#
# Be sure to run `pod lib lint SwiftFeatureConfigs.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftFeatureConfigs'
  s.version          = '0.1.0'
  s.summary          = 'Light weight and type-safe feature toggling for Swift/Objective-c'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This cocoapod provides feature configs to swift and Objective C projects that is type-safe, configurable, simple enough to reason about and powerful enough to adapt to your needs.
  
  Feature configs are controlled via 4 levels of control listed in the order that will take priority first.
  
   * Local plist file stored in the app's NSBundle. This would be most appropriate for a developer working on and individual feature in their own app sandbox or for a QA engineer testing a silently deployed feature for possible side effect regression bugs before releasing a feature to the public.
  
  * In memory store loaded This may be configured at app launch time or after a user logs in to provides run time specific features or AB testing. The in memory settings would be populated with a simple dictionary detailing the feature configs that should be updated. These can then be persisted using persistInMemorySettings for future offline use into the UserDefaults.
  
  * UserDefaults for on device persistant storage. The network will not always be available but your app may have offline features that should still work as they did for the user's last run.
  
  * Feature config's default When the app is first launched each specified feature config should have an initial value to ensure if none of the above have previously been set there is still a sensible default so the app will not (should not) crash.
DESC

  s.homepage         = 'https://github.com/dallasjohnson/SwiftFeatureConfigs'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dallas Johnson' => 'dallasj001@gmail.com' }
  s.source           = { :git => 'https://github.com/dallasjohnson/SwiftFeatureConfigs.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftFeatureConfigs/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftFeatureConfigs' => ['SwiftFeatureConfigs/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

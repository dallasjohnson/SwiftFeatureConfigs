
import Foundation
import Stencil

let featureConfigJSONPath = "featureConfigs.json"
let featureConfigStencilPath = "featureConfig.stencil"
let featureConfigOutputPath = "FeatureConfigs.swift"

enum ParsingError: Error {
    case unexpectedJSONType
}

let configsURL = URL(fileURLWithPath: featureConfigJSONPath)
do {
    let configJSONData = try Data(contentsOf: configsURL)
    guard let json = try JSONSerialization
        .jsonObject(with: configJSONData, options: .allowFragments) as? [String: Any] else { throw ParsingError.unexpectedJSONType }
    let templateURL = URL(fileURLWithPath: featureConfigStencilPath)
    let templateString = try String(contentsOf: templateURL)
    let featuresTemplate = Template(templateString: templateString)
    let rendered = try featuresTemplate.render(json)
    let outputURL = URL(fileURLWithPath: featureConfigOutputPath)
    try rendered.write(to: outputURL, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print("Error occurred: \(error)")
}

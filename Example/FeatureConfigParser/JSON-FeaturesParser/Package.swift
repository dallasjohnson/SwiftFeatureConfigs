import PackageDescription

let package = Package(
  name: "JSON-FeatureParser",
  dependencies: [
    .Package(url: "https://github.com/kylef/Stencil.git", majorVersion: 0, minor: 10),
  ]
)

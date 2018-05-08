UrbanVapor
============
[![CI Status](http://img.shields.io/travis/wmcginty/UrbanVapor.svg?style=flat)](https://travis-ci.org/wmcginty/UrbanVapor)

### Purpose
UrbanVapor is a Vapor 3 `Provider` intended to make it easy to work with Urban Airships Push Notifications API. It is designed to simplify or eliminate 'stringly-typed' parameters, making the API safer to use. 

### Usage
Before using UrbanVapor, you'll need to register it as a `Provider`:

```swift
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    if let key = Environment.get("URBAN_AIRSHIP_KEY"), let secret = Environment.get("URBAN_AIRSHIP_MASTERSECRET") {
        let urbanVapor = UrbanVaporProvider(key: key, secret: secret)
        try services.register(urbanVapor)
    }
}
```

Then, in your route handler, you could do something like:

```swift
router.get("example") { req -> Future<Response> in
    let urbanVapor = try req.make(UrbanVaporService.self)
    let client = try req.client()
    
    return try urbanVapor.send(push: Push(...), on: client)
}
```

### Example

To run the example project, clone the repo, and run `swift build` from the directory.

### Requirements

Swift 4.1

### Installation - SPM

Add the dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/wmcginty/UrbanVapor.git", from: "0.0.1")
```

### Contributing

All contributions are more than welcome - pull requests, cleanup, bug fixes, refactors... whatever! I will be focusing on the UrbanAirship APIs I use most frequently - if you have a different one you'd like to see, create an issue.

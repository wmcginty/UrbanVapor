# UrbanVapor

![CI Status](https://github.com/wmcginty/UrbanVapor/actions/workflows/main.yml/badge.svg)
![Swift](http://img.shields.io/badge/swift-5.5-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-4.0-brightgreen.svg)

## Purpose
UrbanVapor is a Vapor 4 service, intended to make it easy to work with Airship's Push Notifications API. It is designed to simplify or eliminate 'stringly-typed' parameters, making the API safer to use.

## Usage
Before using UrbanVapor, you'll need to provide it with an API key and master secret to enable to it to send push notifications. This is most easily done in `configure.swift`

```swift
if let urbanKey = Environment.get("UA_KEY"), let urbanSecret = Environment.get("UA_SECRET") {
    configureUrbanVapor(withKey: urbanKey, secret: urbanSecret)
}
```

Then, in your route handler, you can use the `request.application` to interact and send notifications.

```swift
router.get("example") { req  in
    let urbanVapor = try req.application.urbanVapor
    urbanVapor.send(payload, using: req.application.client)
    
    try await urbanVapor.send(payload, using: client)
}
```

## Example

To run the example project, clone the repo, and run `swift build` from the directory.

## Requirements

Swift 5.5, Vapor 4.0

## Installation

Add the dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/wmcginty/UrbanVapor.git", from: "0.4.0")
```

## Contributing

All contributions are more than welcome - pull requests, cleanup, bug fixes, refactors... whatever! I will be focusing on the Airship APIs I use most frequently - if you have a different one you'd like to see, create an issue.

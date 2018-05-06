import Vapor

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Configure the rest of your application here
    if let key = Environment.get("URBAN_AIRSHIP_KEY"), let secret = Environment.get("URBAN_AIRSHIP_MASTERSECRET") {
        let urbanVapor = UrbanVaporProvider(key: key, secret: secret)
        try services.register(urbanVapor)
    }
}

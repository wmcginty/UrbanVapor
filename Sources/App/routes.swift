import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

    router.get("test") { req -> Future<Response> in
        let urbanVapor = try req.make(UrbanVaporService.self)
        let client = try req.client()
        return try urbanVapor.validatePush(on: client)
    }
}

import Foundation
import HeliumLogger
import Kitura
import MongoKitten

HeliumLogger.use()


//database connectie opzetten
let database = try! Database("mongodb://127.0.0.1:27017/tabletennisdatabase")
let router = Router()

//sub routerpath maken zodat main niet te groot wordt
configureNewsRouter(on: router.route("/api/news"))
configureSerieRouter(on: router.route("/api/series"))


Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()


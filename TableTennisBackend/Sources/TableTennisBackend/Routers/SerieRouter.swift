import Foundation
import Kitura
import KituraContracts
import LoggerAPI
import MongoKitten

private let series = database["series"]

func configureSerieRouter(on router: Router) {
    router.get("/", handler: getAllSeries)
    router.post("/", handler: addSerie)
    router.get("/", handler: getSerie)
    router.put("/", handler: updateSerie)
    router.delete("/", handler: deleteSerie)
}

 private func getAllSeries(completion: ([Serie]?, RequestError?) -> Void) {
    do {
        let results = try series.find().flatMap(Serie.init)
        completion(results, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}


 
private func addSerie(serie: Serie, completion: (Serie?, RequestError?) -> Void) {
    do {
        guard try series.count(["name": serie.name]) == 0 else {
            return completion(nil, .conflict)
        }
        try series.insert(serie.toBSON())
        completion(serie, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}

/*
 A "get one" handler automatically adds a "/:id" path component.
 It receives this ID as its first parameter. This parameter can be of any type that conforms to the Identifier protocol.
 The handler then returns either the requested instance or an error.
 */
private func getSerie(name: String, completion: (Serie?, RequestError?) -> Void) {
    do {
        guard let bson = try series.findOne(["name": name]) else {
            return completion(nil, .notFound)
        }
        guard let serie = Serie(from: bson) else {
            return completion(nil, .internalServerError)
        }
        completion(serie, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}

/*
 An "update" handler adds a "/:id" path component and receives this ID as its first parameter.
 Its second parameter is the instance that was sent in the request body.
 The handler then returns either the updated instance or an error.
 */
private func updateSerie(name: String, to serie: Serie, completion: (Serie?, RequestError?) -> Void) {
    do {
        guard try series.count(["name": name]) == 1 else {
            return completion(nil, .notFound)
        }
        try series.update(["name": name], to: serie.toBSON())
        completion(serie, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
}

/*
 A "delete" handler adds a "/:id" path component and receives this ID as its first parameter.
 It either returns nil or an error.
 */
private func deleteSerie(name: String, completion: (RequestError?) -> Void) {
    do {
        guard try series.count(["name": name]) == 1 else {
            return completion(.notFound)
        }
        try series.remove(["name": name])
        completion(nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(.internalServerError)
    }
}

/*
 Note that codable routing is still new.
 It is currently being extended to include support for query parameters and form data.
 */


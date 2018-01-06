import Foundation
import Kitura
import KituraContracts
import LoggerAPI
import MongoKitten

private let news = database["news"]

func configureNewsRouter(on router: Router) {
     router.get("/", handler: getAllNews)
     router.post("/", handler: addNewsItem)
     router.get("/", handler: getNewsItem)
     router.put("/", handler: updateNewsItem)
     router.delete("/", handler: deleteNewsItem)
}

private func getAllNews(completion: ([NewsItem]?, RequestError?) -> Void) {
    do {
        let results = try news.find().flatMap(NewsItem.init)
        completion(results, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
 }

 
 private func addNewsItem(newsItem: NewsItem, completion: (NewsItem?, RequestError?) -> Void) {
    do {
        guard try news.count(["title": newsItem.title]) == 0 else {
            return completion(nil, .conflict)
        }
        try news.insert(newsItem.toBSON())
            completion(newsItem, nil)
    } catch {
        Log.error(error.localizedDescription)
        completion(nil, .internalServerError)
    }
 }
 

 /*A "get one" handler automatically adds a "/:id" path component.
 It receives this ID as its first parameter. This parameter can be of any type that conforms to the Identifier protocol.
 The handler then returns either the requested instance or an error.
 */
 private func getNewsItem(title: String, completion: (NewsItem?, RequestError?) -> Void) {
    do {
        guard let bson = try news.findOne(["title": title]) else {
            return completion(nil, .notFound)
        }
        guard let newsItem = NewsItem(from: bson) else {
            return completion(nil, .internalServerError)
        }
        completion(newsItem, nil)
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
private func updateNewsItem(title: String, to newsItem: NewsItem, completion: (NewsItem?, RequestError?) -> Void) {
        do {
            guard try news.count(["title": title]) == 1 else {
                return completion(nil, .notFound)
            }
            try news.update(["title": title], to: newsItem.toBSON())
            completion(newsItem, nil)
        } catch {
            Log.error(error.localizedDescription)
            completion(nil, .internalServerError)
        }
 }
 
 /*
 A "delete" handler adds a "/:id" path component and receives this ID as its first parameter.
 It either returns nil or an error.
 */
 private func deleteNewsItem(title: String, completion: (RequestError?) -> Void) {
    do {
        guard try news.count(["title": title]) == 1 else {
        return completion(.notFound)
        }
        try news.remove(["title": title])
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



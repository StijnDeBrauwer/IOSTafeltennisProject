import KituraKit

/*
 This class provides methods to communicate with the back-end.
 This communication is done using KituraKit, which works much like the codable routing APIs on the back-end.
 */
class KituraService {
    
    /*
     Singleton.
     */
    private init() { }
    static let shared = KituraService()
    
    private let client = KituraKit(baseURL: "http://localhost:8080/api/")!
    
    //News
    func getNews(completion: @escaping ([NewsItem]?) -> Void) {
        client.get("news") {
            (news: [NewsItem]?, error: RequestError?) in
            if let error = error {
                print("Error while loading news: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(news)
            }
        }
    }
    
    func addNewsItem(_ newsItem: NewsItem) {
        client.post("news", data: newsItem) {
            (result: NewsItem?, error: RequestError?) in
            if let error = error {
                print("Error while saving project \(newsItem.title): \(error.localizedDescription)")
            }
        }
    }
    
    func updateNewsItem(withName title: String, to newsItem: NewsItem) {
        client.put("news", identifier: title, data: newsItem) {
            (result: NewsItem?, error: RequestError?) in
            if let error = error {
                print("Error while updating newsitem \(title): \(error.localizedDescription)")
            }
        }
    }
    
    func removeNewsItem(_ newsItem: NewsItem) {
        client.delete("news", identifier: newsItem.title) {
            (error: RequestError?) in
            if let error = error {
                print("Error while removing newsItem \(newsItem.title): \(error.localizedDescription)")
            }
        }
    }
    
    //Series
    
    func getSeries(completion: @escaping ([Serie]?) -> Void) {
        client.get("series") {
            (series: [Serie]?, error: RequestError?) in
            if let error = error {
                print("Error while loading series: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(series)
            }
        }
    }
    
    func getSerie(withName name: String, completion: @escaping (Serie?) -> Void) {
        client.get("series", identifier: name) {
            (serie: Serie?, error: RequestError?) in
            if let error = error {
                print("Error while loading series: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion(serie)
            }
        }
    }
    
    
    
    func addSerie(_ serie: Serie) {
        client.post("series", data: serie) {
            (result: Serie?, error: RequestError?) in
            if let error = error {
                print("Error while saving serie \(serie.name): \(error.localizedDescription)")
            }
        }
    }
    
    func updateSerie(withName name: String, to serie: Serie) {
        client.put("series", identifier: name, data: serie) {
            (result: Serie?, error: RequestError?) in
            if let error = error {
                print("Error while updating serie \(name): \(error.localizedDescription)")
            }
        }
    }
    
    func removeSerie(_ serie: Serie) {
        client.delete("series", identifier: serie.name) {
            (error: RequestError?) in
            if let error = error {
                print("Error while removing serie \(serie.name): \(error.localizedDescription)")
            }
        }
    }
    
}



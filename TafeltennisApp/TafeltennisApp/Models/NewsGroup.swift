
class NewsGroup {
    var title: String
    var newsItems : [NewsItem] = []
    
    init(title: String) {
        self.title = title
    }
    
    func numberOfItems() -> Int {
        return newsItems.count
    }

    
    func tasks() -> [NewsItem] {
        return newsItems
    }
    
    
}

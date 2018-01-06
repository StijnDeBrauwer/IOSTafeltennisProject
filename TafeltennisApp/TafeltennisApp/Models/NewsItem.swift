import UIKit
class NewsItem: Codable {
    var title: String
    var description: String
    var text: String
    
    init(title: String, description: String, text: String) {
        self.title = title
        self.description = description
        self.text = text
    }
}

extension NewsItem: Equatable {
    static func == (lhs: NewsItem, rhs: NewsItem) -> Bool {
        return lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.text == rhs.text
    }
}

extension NewsItem: Hashable {
    var hashValue: Int {
        return title.hashValue ^ description.hashValue ^ text.hashValue
    }
}

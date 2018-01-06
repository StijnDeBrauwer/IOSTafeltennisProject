/*
 var title: String
 var description: String
 var text: String
 */
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

import BSON

extension NewsItem {
    
    convenience init?(from bson: Document) {
        guard let title = String(bson["title"]),
            let description = String(bson["description"]),
            let text = String(bson["text"]) else {
                return nil
        }
        self.init(title: title, description: description, text: text)
    }
    
    func toBSON() -> Document {
        return [
            "title": title,
            "description": description,
            "text": text
        ]
    }
}


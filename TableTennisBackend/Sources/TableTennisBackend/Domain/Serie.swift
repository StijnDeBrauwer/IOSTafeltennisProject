 /*var name: String
 var matches: [Match] = []
 var players: [Player] = []
 var ranking: Ranking*/
 
 
 class Serie: Codable {
    
    var name: String
    var matches: [Match] = []
    var players: [Player] = []

    
    init(name: String) {
        self.name = name
    }
 }
 
 import BSON
 
 extension Serie {
    
    convenience init?(from bson: Document) {
        guard let name = String(bson["name"]),
            let bsonPlayers = Array(bson["players"]),
            let bsonMatches = Array(bson["matches"])
        else {
                return nil
        }
        self.init(name: name)
        matches = bsonMatches.flatMap(Document.init).flatMap(Match.init)
        players = bsonPlayers.flatMap(Document.init).flatMap(Player.init)

    }
    
    func toBSON() -> Document {
        return [
            "name": name,
            "matches": matches.map{$0.toBSON()},
            "players": players.map {$0.toBSON()}
        ]
    }
 }

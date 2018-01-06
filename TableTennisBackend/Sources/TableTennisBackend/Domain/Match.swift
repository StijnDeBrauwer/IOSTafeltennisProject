/*var playerA: Player
var playerB: Player
var setsPlayerA: Int
var setsPlayerB: Int
var date: Date*/

class Match: Codable {
    
    var playerA: Player
    var playerB: Player
    var setsPlayerA: Int
    var setsPlayerB: Int
    var date: String
    
    init(playerA: Player, playerB: Player, setsPlayerA: Int, setsPlayerB: Int, date: String) {
        self.playerA = playerA
        self.playerB = playerB
        self.setsPlayerA = setsPlayerA
        self.setsPlayerB = setsPlayerB
        self.date = date
        
    }
}

import BSON

extension Match {
    
    convenience init?(from bson: Document) {
        guard let date = String(bson["date"]),
            let bsonPlayerA = Document(bson["playerA"]),
            let playerA = Player(from: bsonPlayerA),
            let bsonPlayerB = Document(bson["playerB"]),
            let playerB = Player(from: bsonPlayerB),
            let setsPlayerA = Int(bson["setsPlayerA"]),
            let setsPlayerB = Int(bson["setsPlayerB"])
            else {
                return nil
        }
        self.init(playerA: playerA, playerB: playerB, setsPlayerA: setsPlayerA, setsPlayerB: setsPlayerB, date: date)
    }
    
    func toBSON() -> Document {
        return [
            "playerA": playerA.toBSON(),
            "playerB": playerB.toBSON(),
            "setsPlayerA": setsPlayerA,
            "setsPlayerB": setsPlayerB,
            "date": date
        ]
    }
}




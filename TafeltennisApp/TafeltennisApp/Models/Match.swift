import Foundation

class Match: Codable {
    var playerA: Player
    var playerB: Player
    var setsPlayerA: Int
    var setsPlayerB: Int
    var date: String

    init(playerA: Player, playerB: Player, setsPlayerA: Int, setsPlayerB: Int, date: String){
      
        self.playerA = playerA
        self.playerB = playerB
        self.setsPlayerA = setsPlayerA
        self.setsPlayerB = setsPlayerB
        self.date = date
    }
    
    func getWinner() ->Player {
        if(setsPlayerA == 4){
            
            return playerA
        }else {
            return playerB
        }
    }
    
    private enum CodingKeys: CodingKey {
        case playerA
        case playerB
        case setsPlayerA
        case setsPlayerB
        case date
    }
    
    /*
     This method is required by the Encodable protocol (Codable is actually Encodable & Decodable).
     It is normally generated by the compiler but can be implemented to do custom encoding.
     */
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(playerA, forKey: .playerA)
        try container.encode(playerB, forKey: .playerB)
        try container.encode(setsPlayerA, forKey: .setsPlayerA)
        try container.encode(setsPlayerB, forKey: .setsPlayerB)
        try container.encode(date, forKey: .date)
    }
    
    /*
     This initializer is required by the Decodable protocol.
     It is normally generated by the compiler but can be implemented to do custom decoding.
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let playerA = try container.decode(Player.self, forKey: .playerA)
        let playerB = try container.decode(Player.self, forKey: .playerB)
        let setsPlayerA = try container.decode(Int.self, forKey: .setsPlayerA)
        let setsPlayerB = try container.decode(Int.self, forKey: .setsPlayerB)
        let date = try container.decode(String.self, forKey: .date)
        
        self.playerA = playerA
        self.playerB = playerB
        self.setsPlayerA = setsPlayerA
        self.setsPlayerB = setsPlayerB
        self.date = date
    }
}

extension Match: Equatable {
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.date == rhs.date &&
        lhs.playerA == rhs.playerA &&
        lhs.playerB == rhs.playerB &&
        lhs.setsPlayerA == rhs.setsPlayerA &&
        lhs.setsPlayerB == rhs.setsPlayerB
    }
}

extension Match: Hashable {
    var hashValue: Int {
        return playerA.hashValue ^ playerB.hashValue ^ setsPlayerA.hashValue ^ setsPlayerB.hashValue ^ date.hashValue
    }
}

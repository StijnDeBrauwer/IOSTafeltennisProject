import Foundation
class Player: Codable {
    
    enum Sex: String, Codable {
        case man = "Male"
        case woman = "Female"
        case boy = "Boy"
        case girl = "Girl"
        
        static let values = [Sex.man, .woman, .girl, .boy]
    }
    var sex: Sex
    var firstname: String
    var lastname: String
    var country: String
    var birthdate: String
    var debutYear: Int
    var rankingScore: Int
    init(sex: Sex, firstname: String, lastname: String, country: String, birthdate: String ,debutYear: Int, rankingScore: Int) {
        self.firstname = firstname
        self.lastname = lastname
        self.country = country
        self.birthdate = birthdate
        self.debutYear = debutYear
        self.rankingScore = rankingScore
        self.sex = sex
    }
    
    

}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.firstname == rhs.firstname &&
            lhs.lastname == rhs.lastname &&
            lhs.country == rhs.country &&
            lhs.birthdate == rhs.birthdate &&
            lhs.debutYear == rhs.debutYear &&
            lhs.rankingScore == rhs.rankingScore &&
            lhs.sex == rhs.sex
    }
}

extension Player: Hashable {
    var hashValue: Int {
        return firstname.hashValue ^ lastname.hashValue ^ country.hashValue ^ birthdate.hashValue ^ debutYear.hashValue ^ rankingScore.hashValue
    }
}

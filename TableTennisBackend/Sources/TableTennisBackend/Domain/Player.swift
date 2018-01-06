 /*var sex: Sex
 var firstname: String
 var lastname: String
 var country: String
 var birthdate: Date
 var debutYear: Int
 var rankingScore: Int*/

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
    init(sex: Sex, firstname: String, lastname: String, country: String, birthdate: String, debutYear: Int, rankingScore: Int ) {
        self.sex = sex
        self.firstname = firstname
        self.lastname = lastname
        self.country = country
        self.birthdate = birthdate
        self.debutYear = debutYear
        self.rankingScore = rankingScore
    }
 }
 
 import BSON
 
 extension Player {
    
    convenience init?(from bson: Document) {
        guard let firstname = String(bson["firstname"]),
            let lastname = String(bson["lastname"]),
            let country = String(bson["country"]),
            let birthdate = String(bson["birthdate"]),
            let debutYear = Int(bson["debutYear"]),
            let rankingScore = Int(bson["rankingScore"]),
            let sexRaw = String(bson["sex"]),
            let sex = Sex(rawValue: sexRaw) else {
                return nil
        }
        self.init(sex: sex, firstname: firstname, lastname: lastname, country: country, birthdate: birthdate, debutYear: debutYear, rankingScore: rankingScore)
    }
    
    func toBSON() -> Document {
        return [
            "sex": sex.rawValue,
            "firstname": firstname,
            "lastname": lastname,
            "country": country,
            "birthdate": birthdate,
            "debutYear": debutYear,
            "rankingScore": rankingScore
        ]
    }
 }


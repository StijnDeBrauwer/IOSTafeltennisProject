import UIKit
import Foundation
class MatchDetailViewController: UITableViewController {
    
    
    /*Source: https://developer.apple.com/documentation/foundation/dateformatter */
    
    
    var match: Match?
    var serie: Serie?

    
    @IBOutlet weak var serieLabel: UILabel!
    @IBOutlet weak var playerALabel: UILabel!
    @IBOutlet weak var playerBLabel: UILabel!
    @IBOutlet weak var  scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    
    override func viewDidLoad() {
        if let match = match, let serie = serie{
            let dateString = match.date
            serieLabel.text = serie.name
            playerALabel.text = "\(match.playerA.lastname) \(match.playerA.firstname)"
            playerBLabel.text = "\(match.playerB.lastname) \(match.playerB.firstname)"
            scoreLabel.text = "\(match.setsPlayerA) - \(match.setsPlayerB)"
            dateLabel.text = dateString
        }
        
    }

    func convertDateToString(date: Date) -> String {
        //convert the date to string
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "nl_NL")

        dateFormatter.setLocalizedDateFormatFromTemplate("dMMMMYYYY")
        
        return dateFormatter.string(from: date)
    }
}

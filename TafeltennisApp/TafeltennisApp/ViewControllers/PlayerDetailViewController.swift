import UIKit

class PlayerDetailViewController: UITableViewController {
    
    /*Source: https://developer.apple.com/documentation/foundation/datecomponentsformatter */
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var moreInfoButton: UIButton!

    
    
    var player: Player?
    var serie: Serie?
    var ranking: Int?
    
    override func viewDidLoad() {
    
        if let player = player, let ranking = ranking {
            
            //calculate the age
           let now = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            let stringPlayer = player.birthdate
            let date = dateFormatter.date(from: stringPlayer)
            
            
            let stringAge = Calendar.current.dateComponents([.year], from: date!, to: now).year!
           
            sexLabel.text = player.sex.rawValue
            nameLabel.text =  "\(player.lastname) \(player.firstname)"
            ageLabel.text = "\(stringAge)"
            rankingLabel.text = "\(ranking)"
            countryLabel.text = player.country
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "moreInfo"?:
            let playerResultsViewController = segue.destination as! PlayerResultsViewController
            playerResultsViewController.player = player
            playerResultsViewController.serie = serie
        default:
            fatalError("Unknown segue")
        }
    }
    
    
    
}




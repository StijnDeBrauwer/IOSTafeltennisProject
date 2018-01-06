import UIKit

class RankingCell: UITableViewCell {
    @IBOutlet weak var rankingPlaceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    var rankingInfo: (rankingPlace: Int, player: Player)!{
        didSet {
         nameLabel.text = "\(rankingInfo.player.firstname) \(rankingInfo.player.lastname)"
         countryLabel.text = rankingInfo.player.country
         scoreLabel.text = "\(rankingInfo.player.rankingScore)"
         rankingPlaceLabel.text = "\(rankingInfo.rankingPlace + 1)"
        }
    
    }
    
    
    
    
   
}

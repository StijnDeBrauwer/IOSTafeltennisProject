import UIKit
    
class PlayerCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    var player: Player! {
        didSet {
            nameLabel.text = "\(player.lastname) \(player.firstname)"
            countryLabel.text = player.country
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

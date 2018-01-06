import UIKit

class SerieCell: UITableViewCell {
    
    @IBOutlet weak var serieNameLabel: UILabel!
    
    
    var serie: Serie! {
        didSet {
            serieNameLabel.text = serie.name
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

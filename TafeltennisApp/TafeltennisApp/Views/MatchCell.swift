import UIKit

class MatchCell: UITableViewCell {
    
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var match: Match! {
        didSet {
            let stringDate = match.date
            matchLabel.text = "\(match.playerA.lastname) vs \(match.playerB.lastname)"
            dateLabel.text = stringDate
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func convertDateToString(date: Date) -> String {
        //convert the date to string
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "nl_NL")
        
        dateFormatter.setLocalizedDateFormatFromTemplate("dMMMMYYYY")
        
        return dateFormatter.string(from: date)
    }
}

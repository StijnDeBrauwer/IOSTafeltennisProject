import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    
    var newsItem: NewsItem! {
        didSet {
        titleLabel.text = newsItem.title
        descriptionLabel.text = newsItem.description
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

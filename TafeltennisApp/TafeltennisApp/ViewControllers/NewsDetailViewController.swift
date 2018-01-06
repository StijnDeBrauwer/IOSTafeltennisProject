import UIKit

class NewsDetailViewController: UITableViewController {
    
    var newsItem: NewsItem?
    var showButton: Bool?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        
        if let newsItem = newsItem {
            titleField.text = newsItem.title
            descriptionField.text = newsItem.description
            newsTextView.text = newsItem.text
            saveButton.isEnabled = true
        }
        
        if showButton == false {
           hideButton()
        }
    }
    
    func hideButton() {
        saveButton.isEnabled = false
        saveButton.tintColor = UIColor.clear
        
        titleField.isEnabled = false
        descriptionField.isEnabled = false
        newsTextView.isEditable = false
    }
    
    
    @IBAction func save() {
        validateNews()
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "didAddNewsItem"?:
            newsItem = NewsItem(title: titleField.text!, description: descriptionField.text!, text: newsTextView.text!)
        case "didEditNewsItem"?:
                let title = newsItem!.title
                newsItem!.title = titleField.text!
                newsItem!.description = descriptionField.text!
                newsItem!.text = newsTextView.text!
                KituraService.shared.updateNewsItem(withName: title, to: newsItem!)
        default:
            fatalError("Unknown segue")
        }
    }
    
    func validateNews(){
        if(titleField.text!.isEmpty) {
            showAlert(title: "Please fill in every text field", message: "Please fill in title text to be a valid newsitem")
        } else if(descriptionField.text!.isEmpty) {
                 showAlert(title: "Please fill in every text field", message: "Please fill in description text to be a valid newsitem")
            } else if(newsTextView.text!.isEmpty) {
                     showAlert(title: "Please fill in every text field", message: "Please fill in the text to be a valid newsitem")
        } else {
            if newsItem != nil {
                performSegue(withIdentifier: "didEditNewsItem", sender: self)
            } else {
                performSegue(withIdentifier: "didAddNewsItem", sender: self)
            }
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension NewsDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = titleField.text {
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
            saveButton.isEnabled = newText.count > 0
        } else {
            saveButton.isEnabled = string.count > 0
        }
        return true
    }
}






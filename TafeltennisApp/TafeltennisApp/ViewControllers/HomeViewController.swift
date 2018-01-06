

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var indexPathToEdit: IndexPath!
    
    
    /*var newsItems: [NewsItem] = [
        NewsItem(title: "Timo Boll beats Ma Long", description: "Last week Timo Boll defeated the dragon Ma Long", text: "Test test test"),
        NewsItem(title: "Timo Boll beats Ma Long 2", description: "Last week Timo Boll defeated the dragon Ma Long", text: "Test test test kjqmjdkhteureui!! kfmqjkdqf "),
        NewsItem(title: "Timo Boll beats Ma Long 3", description: "Last week Timo Boll defeated the dragon Ma Long", text: "Test test test mdklqjkqjqmk kjqkqjmkfjq ")
    ]*/

    var newsItems: [NewsItem] = []
    
    var currentNewsItems: [NewsItem] = []
    
    override func viewDidLoad() {
        KituraService.shared.getNews {
            if let newsItems = $0 {
                self.newsItems = newsItems
                self.currentNewsItems = self.newsItems
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "addNewsItem"?: break
        case "editNewsItem"?:
            let newsDetailViewController = segue.destination as! NewsDetailViewController
            newsDetailViewController.newsItem = newsItems[indexPathToEdit.row]
            newsDetailViewController.showButton = true
        case "showNewsDetail"?:
            let newsDetailViewController = segue.destination as! NewsDetailViewController
            let selection = tableView.indexPathForSelectedRow!
            tableView.deselectRow(at: selection, animated: true)
            newsDetailViewController.newsItem = newsItems[selection.row]
            newsDetailViewController.showButton = false
            
        default:
            fatalError("Unknown segue")
        }
    }
    
    
    @IBAction func unwindFromNewsDetail(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didAddNewsItem"?:
            let newsDetailViewController = segue.source as! NewsDetailViewController
            newsItems.append(newsDetailViewController.newsItem!)
            currentNewsItems.append(newsDetailViewController.newsItem!)
            tableView.insertRows(at: [IndexPath(row: newsItems.count - 1, section: 0)], with: .automatic)
            KituraService.shared.addNewsItem(newsItems.last!)
        case "didEditNewsItem"?:
            tableView.reloadRows(at: [indexPathToEdit], with: .automatic)
        default:
            fatalError("Unkown segue")
        }
    }

}


extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (action, view, completionHandler) in
            self.indexPathToEdit = indexPath
            self.performSegue(withIdentifier: "editNewsItem", sender: self)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor.orange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            let deleted = self.currentNewsItems.remove(at: indexPath.row)
            let i = self.newsItems.index(of: deleted)
            let newsItem =  self.newsItems.remove(at: i!)
            
            KituraService.shared.removeNewsItem(newsItem)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentNewsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.newsItem = currentNewsItems[indexPath.row]
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentNewsItems = newsItems
            tableView.reloadData()
            return
        }
        currentNewsItems = newsItems.filter({news -> Bool in
            news.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
   

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}



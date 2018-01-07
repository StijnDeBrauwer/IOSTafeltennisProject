import UIKit
import Foundation
class MatchViewController: UIViewController {
    
    var serie: Serie?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var currentMatches: [Match] = []
    
     private var indexPathToEdit: IndexPath!

    override func viewDidLoad() {
        if let serie = serie {
            currentMatches = serie.matches
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KituraService.shared.getSerie(withName: serie!.name) {
            if let serie = $0 {
                self.serie = serie
                self.currentMatches = serie.matches
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "addMatch"?:
             let addMatchViewController = segue.destination as! AddMatchViewController
            addMatchViewController.serie = serie
        case "editMatch"?:
            let addMatchViewController = segue.destination as! AddMatchViewController
            addMatchViewController.match = currentMatches[indexPathToEdit.row]
            addMatchViewController.serie = serie
        case "showMatchDetail"?:
            let matchDetailViewController = segue.destination as! MatchDetailViewController
            let selection = tableView.indexPathForSelectedRow!
            matchDetailViewController.match = currentMatches[selection.row]
            tableView.deselectRow(at: selection, animated: true)
            matchDetailViewController.serie = serie
            
        default:
            fatalError("Unknown segue")
        }
    }
    
    @IBAction func unwindFromAddMatch(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didAddMatch"?:
            let addMatchViewController = segue.source as! AddMatchViewController
            let match = addMatchViewController.match!
            currentMatches.append(match)
            serie!.matches.append(match)

            //adds a point to the player who won
            serie!.players[serie!.players.index(of: match.getWinner())!].rankingScore+=1
            serie!.orderRanking()
            
            KituraService.shared.updateSerie(withName: serie!.name, to: serie!)
            tableView.insertRows(at: [IndexPath(row: currentMatches.count - 1, section: 0)], with: .automatic)
        case "didEditMatch"?:
            let addMatchViewController = segue.source as! AddMatchViewController
            let oldMatch = addMatchViewController.oldMatch
            let match = addMatchViewController.match
            serie!.changeWinnerMatch(oldMatch: oldMatch!, newMatch: match!)
            KituraService.shared.updateSerie(withName: serie!.name, to: serie!)
            tableView.reloadRows(at: [indexPathToEdit], with: .automatic)
        default:
            fatalError("Unkown segue")
        }
    }
    
}

extension MatchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (action, view, completionHandler) in
            self.indexPathToEdit = indexPath
            self.performSegue(withIdentifier: "editMatch", sender: self)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor.orange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            
            
            // calculate the index of the deleted in the real serie.matches
            let deleted = self.currentMatches.remove(at: indexPath.row)
            
            let i = self.serie!.matches.index(of: deleted)
    
            if let i = i {
                let match =  self.serie!.matches.remove(at: i)
            
                //subtract the rankingscore for that match
                let player = match.getWinner()
                
                let indexPlayer: Int = self.serie!.players.index(of: player)!
                player.rankingScore-=1
                
                self.serie!.players[indexPlayer] = player
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                KituraService.shared.updateSerie(withName: self.serie!.name, to: self.serie!)
                completionHandler(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}



extension MatchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MatchCell
        cell.match = currentMatches[indexPath.row]
        return cell
    }
}

extension MatchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentMatches = serie!.matches
            tableView.reloadData()
            return
        }
        currentMatches = serie!.matches.filter({match -> Bool in
            match.playerA.lastname.lowercased().contains(searchText.lowercased()) || match.playerB.lastname.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
}

extension MatchViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tableView.reloadData()
    }
}


import UIKit
import Foundation

/*Source https://www.youtube.com/watch?v=4RyhnwIRjpA */
class PlayerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var series: [Serie] = []
    
     var players: [Player] = []

    private var currentPlayers: [Player] = []
    private var currentIndexSerie: Int = 0
    
    private var indexPathToEdit: IndexPath!
    
    override func viewDidLoad() {
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                self.series.forEach{serie in serie.players.forEach{player in self.players.append(player)}}
                self.currentIndexSerie = 0
                self.currentPlayers = self.series[0].players
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                self.series.forEach{serie in serie.players.forEach{player in self.players.append(player)}}
                self.currentIndexSerie = 0
                self.currentPlayers = self.series[0].players
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func refreshData() {
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                self.tableView.reloadData()
            }
        }
    }
    
    
   /* func addDummyData() {
        //series
        series.append(Serie(name: "Men's singles", ranking: Ranking()))
        series.append(Serie(name: "Women's singles", ranking: Ranking()))
        series.append(Serie(name: "Boys singles", ranking: Ranking()))
        series.append( Serie(name: "Girls singles", ranking: Ranking()))
    
        
        //  dates
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let exampleDate = formatter.date(from: "2016/10/08")
        
        let birthyearPlayer1 = formatter.date(from: "1989/05/05")
        let birthyearPlayer2 = formatter.date(from: "1980/03/25")
        let birthyearPlayer3 = formatter.date(from: "1994/11/02")
        
        let sex = Player.Sex.man
        //players
        
        let player1 = Player(sex: sex, firstname: "Ma", lastname: "Long", country: "China",birthdate: birthyearPlayer1!, debutYear: 2005, rankingScore: 120)
        let player2 = Player(sex: sex, firstname: "Timo", lastname: "Boll", country: "Germany", birthdate: birthyearPlayer2!, debutYear: 1995, rankingScore: 110)
        let player3 = Player(sex: sex, firstname: "Cederic", lastname: "Nuytinck", country: "Belgium",  birthdate: birthyearPlayer3!, debutYear: 2010, rankingScore: 50)
        
        series[0].matches.append(Match(playerA: player2, playerB: player1, setsPlayerA: 4, setsPlayerB: 2, date: exampleDate! ))
        series[0].matches.append(Match(playerA: player1, playerB: player3, setsPlayerA: 4, setsPlayerB: 0, date: exampleDate! ))
        
        series[0].players.append(player1)
        series[0].players.append(player2)
        series[0].players.append(player3)
        
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "addPlayer"?: break
        case "editPlayer"?:
            let addPlayerViewController = segue.destination as! AddPlayerViewController
            addPlayerViewController.player = currentPlayers[indexPathToEdit.row]
        case "showPlayerDetail"?:
            let playerDetailViewController = segue.destination as! PlayerDetailViewController
            let selection = tableView.indexPathForSelectedRow!
            playerDetailViewController.player = currentPlayers[selection.row]
            tableView.deselectRow(at: selection, animated: true)
            playerDetailViewController.ranking = series[currentIndexSerie].getRankingPlayer(selectedPlayer: currentPlayers[selection.row])
            playerDetailViewController.serie = series[currentIndexSerie]
        default:
            fatalError("Unknown segue")
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromAddPlayer(_ segue: UIStoryboardSegue) {
        switch segue.identifier {
        case "didAddPlayer"?:
            let addPlayerViewController = segue.source as! AddPlayerViewController
            let player = addPlayerViewController.player!
            let i = determineSerie(sex: player.sex)
            
            if(!(series[i].playerAlreadyExists(firstname: player.firstname, lastname: player.lastname))){
                //add the player and set it's ranking
                currentPlayers.append(addPlayerViewController.player!)
                players.append(addPlayerViewController.player!)
                series[i].players.append(player)
                series[i].orderRanking()
                
                tableView.insertRows(at: [IndexPath(row: currentPlayers.count - 1, section: 0)], with: .automatic)
                KituraService.shared.updateSerie(withName: series[i].name, to: series[i])
            } else {
                showAlert(title: "Player already exists", message: "Player was not added because a player with this name already exists")
            }
           
        case "didEditPlayer"?:
            let addPlayerViewController = segue.source as! AddPlayerViewController
            series[currentIndexSerie].changeMatchesWithNewPlayer(oldplayer: addPlayerViewController.oldPlayer!, newplayer: addPlayerViewController.player!)
            KituraService.shared.updateSerie(withName: series[currentIndexSerie].name, to: series[currentIndexSerie])
            tableView.reloadRows(at: [indexPathToEdit], with: .automatic)
        default:
            fatalError("Unkown segue")
        }
    }

    func determineSerie(sex: Player.Sex) -> Int{
        switch sex {
        case Player.Sex.man: return 0
        case .woman: return 1
        case .boy: return 2
        case .girl: return 3
        }
    }
    
}

extension PlayerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (action, view, completionHandler) in
            self.indexPathToEdit = indexPath
            self.performSegue(withIdentifier: "editPlayer", sender: self)
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor.orange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completionHandler) in
            let player = self.currentPlayers.remove(at: indexPath.row)
            let index = self.series[self.currentIndexSerie].players.index(of: player)
        
            
            
            //delete the real player at the right index in series.player
            let deletedPlayer = self.series[self.currentIndexSerie].players.remove(at:index!)
            //delete every match from the player
            let newMatches = self.series[self.currentIndexSerie].matches.filter({$0.playerA != deletedPlayer && $0.playerB != deletedPlayer})
            
             self.series[self.currentIndexSerie].matches = newMatches
            
            KituraService.shared.updateSerie(withName: self.series[self.currentIndexSerie].name, to: self.series[self.currentIndexSerie])
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

extension PlayerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerCell
        cell.player = currentPlayers[indexPath.row]
        return cell
    }
}


extension PlayerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentPlayers = players
            tableView.reloadData()
            return
        }
        currentPlayers = players.filter({player -> Bool in
           player.firstname.lowercased().contains(searchText.lowercased()) || player.lastname.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        players = []
         series.forEach{serie in serie.players.forEach{player in players.append(player)}}
        switch selectedScope {
         case 0:
            currentIndexSerie = 0
           
         case 1:
            currentIndexSerie = 1
         case 2:
            currentIndexSerie = 2
         case 3:
            currentIndexSerie = 3
         default: currentPlayers = players
        }
         currentPlayers = series[currentIndexSerie].players
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

extension PlayerViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tableView.reloadData()
    }
}

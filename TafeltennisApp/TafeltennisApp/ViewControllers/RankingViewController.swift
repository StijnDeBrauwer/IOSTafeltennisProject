import UIKit

class RankingViewController: UIViewController {
    @IBOutlet weak var rankingTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var series: [Serie] =  []
    
    var currentRanking: [Player] =  []
    
    var currentList: [Player] = []
    
    var currentSerie: Int = 0
    
    override func viewDidLoad() {
       // initPlayers()
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                //depends on the serie
                self.currentSerie = 0
                self.currentRanking = self.series[0].players
                // The current list from the searchbar results
                self.currentList = self.currentRanking
                self.rankingTable.reloadData()
            }
        }
    
    }
    
    @IBAction func refreshData() {
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                self.currentRanking = self.series[self.currentSerie].players
                self.currentList = self.currentRanking
                self.rankingTable.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                self.currentRanking = self.series[self.currentSerie].players
                self.currentList = self.currentRanking
                self.rankingTable.reloadData()
            }
        }
    }
}


extension RankingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell", for: indexPath) as! RankingCell
        cell.rankingInfo = (rankingPlace: currentList.index(of: currentList[indexPath.row])! , player: currentList[indexPath.row])
        return cell
    }
}

extension RankingViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}



extension RankingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentList = currentRanking
            rankingTable.reloadData()
            return
        }
            currentList = currentRanking.filter({ranking -> Bool in
            ranking.lastname.lowercased().contains(searchText.lowercased()) || ranking.firstname.lowercased().contains(searchText.lowercased())
        })
        rankingTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentSerie = 0
        case 1:
            currentSerie = 1
        case 2:
            currentSerie = 2
        case 3:
            currentSerie = 3
        default: fatalError("Ongeldig")
        }
        series[currentSerie].orderRanking()
        currentRanking = series[currentSerie].players
        currentList = currentRanking
        rankingTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension RankingViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        rankingTable.reloadData()
    }
}

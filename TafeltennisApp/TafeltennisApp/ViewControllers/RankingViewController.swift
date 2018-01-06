import UIKit

class RankingViewController: UIViewController {
    @IBOutlet weak var rankingTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var series: [Serie] =  []
    
    var currentRanking: [Player] =  []
    
    var currentList: [Player] = []
    
    override func viewDidLoad() {
       // initPlayers()
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                //depends on the serie
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
                self.currentRanking = self.series[0].players
                self.currentList = self.currentRanking
                self.rankingTable.reloadData()
            }
        }
    }
    
    /*func initPlayers()  {
        //Men
        //  dates
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let birthyearPlayer1 = formatter.date(from: "1989/05/05")
        let birthyearPlayer2 = formatter.date(from: "1980/03/25")
        let birthyearPlayer3 = formatter.date(from: "1994/11/02")
        
        let sex = Player.Sex.man
        let player1 = Player(sex: sex, firstname: "Ma", lastname: "Long", country: "China",birthdate: birthyearPlayer1! , debutYear: 2005, rankingScore: 120)
        let player2 = Player(sex: sex, firstname: "Timo", lastname: "Boll", country: "Germany", birthdate: birthyearPlayer2!, debutYear: 1995, rankingScore: 110)
        let player3 = Player(sex: sex, firstname: "Cederic", lastname: "Nuytinck", country: "Belgium",  birthdate: birthyearPlayer3!, debutYear: 2010, rankingScore: 50)
        

        let rankingMen = Ranking()
        rankingMen.list.append(player1)
        rankingMen.list.append(player2)
        rankingMen.list.append(player3)
        
        
        
        series.append(Serie(name: "Men's singles", ranking: rankingMen))
        
        
        let wsex = Player.Sex.woman
        let wplayer1 = Player(sex: wsex, firstname: "Ding", lastname: "Ning", country: "China",birthdate: birthyearPlayer1! , debutYear: 2005, rankingScore: 120)
        let wplayer2 = Player(sex: wsex, firstname: "Tessa", lastname: "Vervoort", country: "Belgium", birthdate: birthyearPlayer2!, debutYear: 1995, rankingScore: 110)
        let wplayer3 = Player(sex: wsex, firstname: "Olga", lastname: "Deburich", country: "Russia",  birthdate: birthyearPlayer3!, debutYear: 2010, rankingScore: 50)
        
        let rankingWomen = Ranking()
        rankingWomen.list.append(wplayer1)
        rankingWomen.list.append(wplayer2)
        rankingWomen.list.append(wplayer3)
        
        series.append(Serie(name: "Women's singles", ranking: rankingWomen))
        
        
        series.append(Serie(name: "Boys singles", ranking: Ranking()))
        series.append( Serie(name: "Girls singles", ranking: Ranking()))
    }*/
    
    
    
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
            series[0].orderRanking()
            currentRanking = series[0].players
        case 1:
            series[1].orderRanking()
            currentRanking = series[1].players
        case 2:
            series[2].orderRanking()
            currentRanking = series[2].players
        case 3:
            series[3].orderRanking()
            currentRanking = series[3].players
        default: fatalError("Ongeldig")
        }
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

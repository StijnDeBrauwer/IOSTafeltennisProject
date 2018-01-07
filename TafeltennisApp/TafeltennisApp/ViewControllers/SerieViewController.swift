import UIKit

class SerieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var series: [Serie] = []
    
    
    override func viewDidLoad() {
        //addDummyData()
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                self.tableView.reloadData()
            }
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch  segue.identifier {
        case "showMatches"?:
            let matchViewController = segue.destination as! MatchViewController
            let selection = tableView.indexPathForSelectedRow!
            tableView.deselectRow(at: selection, animated: true)
            matchViewController.serie = series[selection.row]
        default:
            fatalError("Unknown segue")
        }
    }
    
    /*func addDummyData() {
        //series
        series.append(Serie(name: "Men's singles", ranking: Ranking()))
        series.append(Serie(name: "Women's singles", ranking: Ranking()))
        series.append(Serie(name: "Boys singles", ranking: Ranking()))
        series.append( Serie(name: "Girls singles",  ranking: Ranking()))
        
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

    
    
    
}


extension SerieViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serieCell", for: indexPath) as! SerieCell
        cell.serie = series[indexPath.row]
        return cell
    }
}


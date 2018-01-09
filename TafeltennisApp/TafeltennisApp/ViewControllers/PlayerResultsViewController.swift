import UIKit
import Charts
/*Source: https://github.com/danielgindi/Charts
 imagepicker indien genoeg tijd
 */

class PlayerResultsViewController: UIViewController, ChartViewDelegate  /* UINavigationControllerDelegate, UIImagePickerControllerDelegate*/ {
    //@IBOutlet weak var imagePlayer: UIImageView!
    @IBOutlet weak var chartView: LineChartView!
    
    var serie: Serie?
    
    var player: Player?

    var currentScore = 0
   /* func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imagePlayer.image = selectedImage

        dismiss(animated: true, completion: nil)
    }*/
    
    func setChart(){
        chartView.delegate = self
        

        
        //een index:win of verlies
        //var entries: [Int:Int] = [0:0]
        var dataset: [ChartDataEntry] = []
        let matchesPlayed =  serie!.matchesOfPlayer(player: player!)
        let datums = matchesPlayed.map{
            String($0.date.prefix(5))
            
            
        }
        let scores: [Int] = matchesPlayed.map {match -> Int in
            let winner = match.getWinner()
             if(winner.firstname == player!.firstname  && winner.lastname == player!.lastname){
                 currentScore+=1
             }
            return currentScore
        }
        
        
       
        
        for i in 0..<scores.count {
            let entry = ChartDataEntry(x: Double(i), y: Double(scores[i]))
            dataset.append(entry)
        }
        
        let dataSet = LineChartDataSet(values: dataset, label: "Aantal rankingpunten")
        let data = LineChartData(dataSets: [dataSet])
        chartView.data = data
        
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:datums)
        
        chartView.leftAxis.granularityEnabled = true
        chartView.leftAxis.granularity = 1
        chartView.leftAxis.axisMinimum = 0
        
        chartView.rightAxis.granularity = 1
        chartView.rightAxis.axisMinimum = 0
        
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.granularity = 1
        chartView.xAxis.axisMinimum = 0
        
        chartView.rightAxis.drawLabelsEnabled = false
    


    }
    
    override func viewDidLoad() {
        if let player = player {
            title = "\(player.firstname) \(player.lastname)"
            setChart()
        }
    
        
    }
    
    /*@IBAction func pickImage(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    
    }*/

}

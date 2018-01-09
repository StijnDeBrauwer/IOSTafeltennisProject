import UIKit

class AddMatchViewController: UIViewController {
    
    var match: Match?
    var serie: Serie?
    var oldMatch: Match?
    var playersSerie: [Player] = []
    
    
    @IBOutlet weak var playerAPicker: UIPickerView!
    @IBOutlet weak var playerBPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setsPlayerA: UITextField!
    @IBOutlet weak var setsPlayerB: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    
override func viewDidLoad() {
    
    datePicker.maximumDate = Date()
    playerAPicker.selectRow(0, inComponent: 0, animated: false)
    playerBPicker.selectRow(1, inComponent: 0, animated: false)
      
        // altijd een serie nodig voor spelers te kunnen kiezen
    if let serie = serie {
            playersSerie = serie.players

        }
    
    if let match = match {
        title = "Edit match \(match.playerA.lastname) vs \(match.playerB.lastname)"
        
        let playerAIndex: Int = serie!.getRankingPlayer(selectedPlayer: match.playerA) - 1
        let playerBIndex: Int =  serie!.getRankingPlayer(selectedPlayer: match.playerB) - 1
            playerAPicker.selectRow(playerAIndex, inComponent: 0, animated: false)
            playerBPicker.selectRow(playerBIndex, inComponent: 0, animated: false)
            setsPlayerA.text = "\(match.setsPlayerA)"
            setsPlayerB.text = "\(match.setsPlayerB)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let matchDate = match.date
        let newDate = dateFormatter.date(from: match.date)
        datePicker.date = newDate!
        

        
        
        oldMatch = Match(playerA: serie!.players[playerAIndex], playerB: serie!.players[playerBIndex], setsPlayerA: Int(setsPlayerA.text!)!, setsPlayerB: Int(setsPlayerB.text!)!, date: matchDate)
        }
    
    
    }
    
    @IBAction func moveFocus() {
        setsPlayerA.resignFirstResponder()
        setsPlayerB.becomeFirstResponder()
    }
    
    @IBAction func save() {
        validateMatch()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        
        switch segue.identifier {
        case "didAddMatch"?:
            let playerA = playersSerie[playerAPicker.selectedRow(inComponent: 0)]
            let playerB = playersSerie[playerBPicker.selectedRow(inComponent: 0)]
        
      
            match = Match(playerA: playerA, playerB: playerB, setsPlayerA: Int(setsPlayerA.text!)!, setsPlayerB: Int(setsPlayerB.text!)!, date: date)
        
            
            
        case "didEditMatch"?:
         
            if let match = match{

                let playerA = playersSerie[playerAPicker.selectedRow(inComponent: 0)]
                let playerB = playersSerie[playerBPicker.selectedRow(inComponent: 0)]
                match.playerA = playerA
                match.playerB = playerB
                match.date = date
                match.setsPlayerA = Int(setsPlayerA.text!)!
                match.setsPlayerB = Int(setsPlayerB.text!)!
            
            }
           
        default:
            fatalError("Unknown segue")
        }
    }
    
    func validateMatch(){
        if(serie!.players.count >= 2) {
        let playerA = playersSerie[playerAPicker.selectedRow(inComponent: 0)]
        let playerB = playersSerie[playerBPicker.selectedRow(inComponent: 0)]
        
         if((setsPlayerA.text!.isEmpty && setsPlayerB.text!.isEmpty) || (setsPlayerA.text!.isEmpty || setsPlayerB.text!.isEmpty)) {
         showAlert(title: "Please fill in all fields", message: "Please fill the sets ")
         } else if !(isValidScore(setsA: Int(setsPlayerA.text!)!, setsB: Int(setsPlayerB.text!)!)){
            showAlert(title: "Give a valid score", message: "The sets of each player must be between 0 and 4, there must be one player that has 4 sets and one player that has less than 4 sets!")
         } else if(playerA == playerB) {
            showAlert(title: "Players cannot be equal", message: "Please select two different players")
            
         }
         else {
         if match != nil {
         performSegue(withIdentifier: "didEditMatch", sender: self)
         } else {
         performSegue(withIdentifier: "didAddMatch", sender: self)
                }
            }
        } else {
            showAlert(title: "No players available", message: "You need to have at least 2 players")
        }
    }
    
    func isValidScore(setsA: Int, setsB: Int) -> Bool {
        if((setsA != setsB) && (setsA >= 0) && (setsB >= 0)  && ((setsA == 4 && setsB < 4) || (setsB == 4 && setsA < 4))){
            return true
        }else {
            return false
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension AddMatchViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return serie!.players.count
    }
}

extension AddMatchViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return serie!.players[row].lastname
    }
}


extension AddMatchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.setsPlayerB {
             textField.endEditing(true)
        }
        return true
    }
}


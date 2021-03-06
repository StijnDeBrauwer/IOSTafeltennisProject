import UIKit

class AddPlayerViewController: UITableViewController {
    var player: Player?
    var oldPlayer: Player?
    var series: [Serie]?
    var currentIndexSerie: Int = 0
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var countrynameTextField: UITextField!
    @IBOutlet weak var debutYear: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var sexPicker: UIPickerView!
    
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
      
        KituraService.shared.getSeries {
            if let series = $0 {
                self.series = series
                self.currentIndexSerie = 0
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        let minDate = dateFormatter.date(from: "01/01/1900")
        let defaultDate = dateFormatter.date(from: "01/01/1990")
        
        
        datePicker.maximumDate = Date()
        datePicker.date = defaultDate!
        datePicker.minimumDate = minDate
    
        
        
        if let player = player {
            //make oldPlayer
            //let sex = Player.Sex.values[sexPicker.selectedRow(inComponent: 0)]
            
            
            title = "\(player.firstname) \(player.lastname)"
            firstnameTextField.text = player.firstname
            lastnameTextField.text = player.lastname
            countrynameTextField.text = player.country
            debutYear.text = "\(player.debutYear)"
            
            let sexIndex = Player.Sex.values.index(of: player.sex)!
            sexPicker.selectRow(sexIndex, inComponent: 0, animated: false)
            
            sexPicker.isUserInteractionEnabled = false
            
            let sex = Player.Sex.values[sexPicker.selectedRow(inComponent: 0)]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let newDate = dateFormatter.date(from: player.birthdate)
            datePicker.date = newDate!
            
            let date = convertDateToString(date: datePicker.date)
            
            oldPlayer = Player(sex: sex , firstname: firstnameTextField.text!, lastname: lastnameTextField.text!, country: countrynameTextField.text!, birthdate: date , debutYear: Int(debutYear.text!)!, rankingScore: player.rankingScore)
          
        }
    }
    
    @IBAction func save() {
        validatePlayer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "didAddPlayer"?:
            let sex = Player.Sex.values[sexPicker.selectedRow(inComponent: 0)]
          
            let date = convertDateToString(date: datePicker.date)
            
            player = Player(sex: sex ,firstname: firstnameTextField.text!, lastname: lastnameTextField.text!, country: countrynameTextField.text!, birthdate: date, debutYear: Int(debutYear.text!)!, rankingScore: 0)
            
            
        case "didEditPlayer"?:
             if let player = player  {
              
                let date = convertDateToString(date: datePicker.date)
            
                player.firstname = firstnameTextField.text!
                player.lastname = lastnameTextField.text!
                player.birthdate = date
                player.country = countrynameTextField.text!
                player.debutYear = Int(debutYear.text!)!
                
            }
            
        default:
            fatalError("Unknown segue")
        }
    }
    
    func validatePlayer(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let birthyear = Int(dateFormatter.string(from:datePicker.date))
        let currentyear = Int(dateFormatter.string(from: Date()))
        
         let sex = Player.Sex.values[sexPicker.selectedRow(inComponent: 0)]
        
        switch(determineSex(sex: sex)) {
            case 0: currentIndexSerie = 0
            case 1: currentIndexSerie = 1
            case 2: currentIndexSerie = 2
            case 3: currentIndexSerie = 3
            default: fatalError()
        }
        
    
        
        if(firstnameTextField.text!.isEmpty || lastnameTextField.text!.isEmpty || countrynameTextField.text!.isEmpty || debutYear.text!.isEmpty ) {
            showAlert(title: "Please fill in all fields", message: "Please fill all textfields ")
        } else if (birthyear! > Int(debutYear.text!)!){
            showAlert(title: "Invalid date", message: "Please choose a valid date, debut year cannot be greater than date of birth")
        } else if(Int(debutYear.text!)! > currentyear!) {
            showAlert(title: "Invalid debut year", message: "The debut year cannot be greater than this year")
        } else if (self.series![currentIndexSerie].playerAlreadyExists(firstname: firstnameTextField.text!, lastname: lastnameTextField.text!)) {
            showAlert(title: "Player already exists", message: "Player was not added because a player with this name already exists")
        }
            else {
                if player != nil {
                    performSegue(withIdentifier: "didEditPlayer", sender: self)
                } else {
                    performSegue(withIdentifier: "didAddPlayer", sender: self)
                }
            }
    
        
    }
    
    func determineSex(sex: Player.Sex) -> Int {
        switch sex {
        case Player.Sex.man: return 0
        case .woman: return 1
        case .boy: return 2
        case .girl: return 3
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func convertDateToString(date: Date) -> String {
        //convert the date to string
        let dateFormatter = DateFormatter()
        
        //dateFormatter.setLocalizedDateFormatFromTemplate("nl_NL")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: date)
    }
}

extension AddPlayerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Player.Sex.values.count
    }
}

extension AddPlayerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Player.Sex.values[row].rawValue
    }
}

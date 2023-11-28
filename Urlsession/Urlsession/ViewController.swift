//
//  ViewController.swift
//  Urlsession
//
//  Created by muhammed fatih elçi on 28.11.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var one: UILabel!
    
    @IBOutlet weak var two: UILabel!
    
    @IBOutlet weak var three: UILabel!
    
    @IBOutlet weak var four: UILabel!
    
    @IBOutlet weak var five: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buton(_ sender: Any) {
        
        // 1) Request & Session
        // 2) Response & Data
        // 3) Parsing & JSON Serialization
        
        //1.
        
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/CurrencyData/main/currency.json")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true,completion: nil)
            }else {
                
                if data != nil {
                    
                    do {
                        let jsonresponse = try                     JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        DispatchQueue.main.async {
                            if let rates = jsonresponse["rates"] as? [String : Any] {
                                
                                if let cad = rates["CAD"] as? Double {
                                    self.one.text = "Cad : \(cad)"
                                }
                                if let gbp = rates["GBP"] as? Double {
                                    self.two.text = "Gbp : \(gbp)"
                                }
                                if let jpy = rates["JPY"] as? Double {
                                    self.three.text = "Jpy : \(jpy)"
                                }
                                if let usd = rates["USD"] as? Double {
                                    self.four.text = "Usd : \(usd)"
                                }
                                if let trya = rates["TRY"] as? Double {
                                    self.five.text = "Try : \(trya)"
                                }
                            }
                        }
                        
                    }catch {
                        print("error")
                    }
                }
                
            }
        }
        task.resume()
    }
}

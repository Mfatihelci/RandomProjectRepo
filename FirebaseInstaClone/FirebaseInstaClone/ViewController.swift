//
//  ViewController.swift
//  FirebaseInstaClone
//
//  Created by muhammed fatih elçi on 29.11.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        //burasi firebase icin mail ile giris yapar

        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleUpdate: "Error!", messageUpdate: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleUpdate: "Error!", messageUpdate: "Username/Password")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        //burasi firebase icin mail kaydetme
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                
                if error != nil {
                    self.makeAlert(titleUpdate: "Error!", messageUpdate: error?.localizedDescription ?? "errror")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            makeAlert(titleUpdate: "Error!", messageUpdate: "Usernama/Password?")
        }
    }
    
    func makeAlert(titleUpdate: String,messageUpdate: String) {
        let alert = UIAlertController(title: titleUpdate, message: messageUpdate, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}


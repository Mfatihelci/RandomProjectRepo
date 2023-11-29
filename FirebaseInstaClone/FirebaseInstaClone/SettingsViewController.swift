//
//  SettingsViewController.swift
//  FirebaseInstaClone
//
//  Created by muhammed fatih elçi on 29.11.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOut(_ sender: Any) {
        //kullanici buradncikis yapar ve firebasedende cikis yapar
        do{
         try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch {
          print("error")
        }
    }
    
}

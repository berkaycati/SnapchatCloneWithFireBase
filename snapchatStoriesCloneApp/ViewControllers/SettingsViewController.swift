//
//  SettingsViewController.swift
//  snapchatStoriesCloneApp
//
//  Created by Berkay on 24.10.2022.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    let currentUser = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        
        if currentUser != nil {
            
            do {
                try Auth.auth().signOut()
                performSegue(withIdentifier: "toMainVC", sender: nil)
            } catch {
                print("Error occured")
            }
            
            
        }
        
    }
    

}

//
//  ViewController.swift
//  snapchatStoriesCloneApp
//
//  Created by Berkay on 22.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var MainLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailTextField.text != "" && nicknameTextField.text != "" && passwordTextField.text != "" {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { auth, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    
                    let FirebaseStoreControl = Firestore.firestore()
                    let userDict = ["email" : self.emailTextField.text! , "nickname" : self.nicknameTextField.text!] as [String : Any]
                    FirebaseStoreControl.collection("usersInfo").addDocument(data: userDict)
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            performSegue(withIdentifier: "toFeedVC", sender: nil)
            
        } else {
            makeAlert(title: "Error", message: "Nickname/Email or Password? has some problem")
        }
        
    }
    @IBAction func signInClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { auth, error in
                if error != nil {
                    self.makeAlert(title: "Eror", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(title: "Error", message: "Check the textes above")
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
}


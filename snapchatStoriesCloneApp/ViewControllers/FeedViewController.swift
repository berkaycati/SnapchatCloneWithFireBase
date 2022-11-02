//
//  FeedViewController.swift
//  snapchatStoriesCloneApp
//
//  Created by Berkay on 24.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDataBase = Firestore.firestore()
    
    var userEmailArray = [String()]
    var uuidArray : UUID?
    var nicknameARray = [String()]
    var snapArray = [Snap]()
    
    var chosenSnap : Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        getUserInfo()
        getSnapsFromFirebase()
        
        self.snapArray.removeAll(keepingCapacity: false)
        self.userEmailArray.removeAll(keepingCapacity: false)
        self.nicknameARray.removeAll(keepingCapacity: false)
        
        
    }
    
    
    func getUserInfo() { // When FeedVC is opened, all the values that we need are going to cast as UserSingleton for one time. And we can use anytime we want this is easier method.
        
        fireStoreDataBase.collection("usersInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email).getDocuments { snapShot, error in
            if error != nil {
                self.makeAlert(title: "error", message: error?.localizedDescription ?? "Error")
            } else {
                for documents in snapShot!.documents {
                    if let nickname = documents.get("nickname") as? String {
                        UserSingleton.sharedInfo.email = Auth.auth().currentUser!.email!
                        UserSingleton.sharedInfo.nickname = nickname
                    }
                }
            }
            
        }
    }
        
    func getSnapsFromFirebase() {

        self.snapArray.removeAll()
        self.userEmailArray.removeAll()
        self.nicknameARray.removeAll()
        
        fireStoreDataBase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { QuerySnapshotss, error in
            if error != nil {
                self.makeAlert(title: "Somethings Wrong!", message: error?.localizedDescription ?? "Error")
            } else {
                if QuerySnapshotss?.isEmpty == false && QuerySnapshotss != nil {
                    for document in QuerySnapshotss!.documents {
                        
                        if let username = document.get("snapOwner") as? String {
                            
                            if let imageURLArray = document.get("imageURLArray") as? [String] {
                                
                                if let date = document.get("date") as? Timestamp {
                                    
                                    let documentId = document.documentID
                                    if let differences = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        
                                        if differences >= 24 {
                                            
                                            // Deleting part
                                            self.fireStoreDataBase.collection("Snaps").document(documentId).delete { error in
                                                if error == nil {
                                                    
                                                }
                                            }
                                        } else {
                                            let snap = Snap(nickname: username, imageURLArray: imageURLArray, date: date.dateValue(), timeLeft: 24 - differences)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
        }
        
    }
        
        
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCellPart
        cell.feedUserNameLabel.text = snapArray[indexPath.row].nickname
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageURLArray[0]))
        return cell
    }
    
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowSnapsVC" {
            let destinationVC = segue.destination as! SnapShowViewController
            destinationVC.selectedSnap = chosenSnap
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = snapArray[indexPath.row]
        performSegue(withIdentifier: "toShowSnapsVC", sender: nil)
    }
}




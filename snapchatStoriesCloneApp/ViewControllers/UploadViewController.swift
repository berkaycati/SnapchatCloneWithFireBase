//
//  UploadViewController.swift
//  snapchatStoriesCloneApp
//
//  Created by Berkay on 24.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestRecTapped))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }

    @IBAction func uploadClicked(_ sender: Any) {
        
        //Storage Part
        
        let storage = Storage.storage()
        let referenceForStorage = storage.reference()
        let mediaFolder = referenceForStorage.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }
                else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            let fireStore = Firestore.firestore()
                            
                            //Firestore part
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedInfo.nickname).getDocuments { snapshots, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    if snapshots?.isEmpty == false && snapshots != nil {
                                        for document in snapshots!.documents {
                                            let documentId = document.documentID
                                            if var imageURLArray = document.get("imageURLArray") as? [String] {
                                                imageURLArray.append(imageURL!)
                                                let additionalDictionary = ["imageURLArray" : imageURLArray] as [String : Any]
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageView.image = UIImage(named: "select.jpg")
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        let snapDictionary = ["imageURLArray" : [imageURL!], "snapOwner" : UserSingleton.sharedInfo.nickname, "date" : FieldValue.serverTimestamp()] as! [String : Any]
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            if error != nil {
                                                self.makeAlert(title: "Error?", message: error?.localizedDescription ?? "Error")
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.imageView.image = UIImage(named: "select.jpg")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func gestRecTapped() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
        
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}

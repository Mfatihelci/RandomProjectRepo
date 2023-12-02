//
//  UploadViewController.swift
//  FirebaseInstaClone
//
//  Created by muhammed fatih elçi on 29.11.2023.
//

import UIKit
import Firebase
import FirebaseStorage

//uiimagepickerview kullanıcının fotoğraf albümlerinden veya cihaz kamerasından medya seçmesine ve bu medyayı seçildiğinde uygulama içinde kullanmanıza olanak tanır.
class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadText: UIButton!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //burda fotograi dokunabilir hale getiriyoruz
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    //fotograin nerden gelicegini ayarlar
    @objc func chooseImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    //kullanici secince ne olucagini yapiyor
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
    }
    
    func makeAlert(titleInput:String,messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true,completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("fatihmedia")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReerence = mediaFolder.child("\(uuid).jpg")
            imageReerence.putData(data,metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                }else {
                    
                    imageReerence.downloadURL { url, error in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference: DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl": imageUrl!,"postedBy" : Auth.auth().currentUser!.email!,"postComment" : self.commentText.text!,"date" : FieldValue.serverTimestamp(),"likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                } else {
                                    
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}

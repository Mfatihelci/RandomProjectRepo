//
//  DetailViewController.swift
//  pano
//
//  Created by muhammed fatih elçi on 14.11.2023.
//

import UIKit
import CoreData

class DetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var artistLabel: UITextField!
    @IBOutlet weak var yearLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var chosenPainting = ""
    var chosenPaintingId: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenPainting != "" {
            
            saveButton.isHidden = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            let idString = chosenPaintingId?.uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        
                        if let name = result.value(forKey: "name") as? String {
                            nameLabel.text = name
                        }
                        if let artist = result.value(forKey: "artist") as? String {
                            artistLabel.text = artist
                        }
                        if let year = result.value(forKey: "year") as? Int {
                            yearLabel.text = String(year)
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data{
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                    }
                }
            } catch  {
                print("hata ayikladi")
        }
        }else {
            saveButton.isHidden = false
            saveButton.isEnabled = false
            nameLabel.text = ""
            artistLabel.text = ""
            yearLabel.text = ""
        }
         
        let gestoreRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestore))
        view.addGestureRecognizer(gestoreRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
    }
    
    @objc func selectedImage() {
        let picker = UIImagePickerController()
        picker.delegate  = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }
    @objc func tapGestore() {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        saveButton.isEnabled = true
        dismiss(animated: true,completion: nil)
    }

    @IBAction func saveButton(_ sender: Any) {
        let AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = AppDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        newPainting.setValue(nameLabel.text, forKey: "name")
        newPainting.setValue(artistLabel.text, forKey: "artist")
        newPainting.setValue(UUID(), forKey: "id")
        
        if let year = Int(yearLabel.text!) {
            newPainting.setValue(year, forKey: "year")
        }
        
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        newPainting.setValue(data, forKey: "image")
        
        do{
            try context.save()
            print("success")
        }catch {
            print("hata var")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}

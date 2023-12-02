//
//  ViewController.swift
//  MachineLearning
//
//  Created by muhammed fatih elçi on 2.12.2023.
//
//
import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!

    var chosenImage = CIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changeButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)

        if let ciImage = CIImage(image: imageView.image!) {
            chosenImage = ciImage
        }

        recognizeImage(image: chosenImage)
    }

    func recognizeImage(image: CIImage) {
        if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
            let request = VNCoreMLRequest(model: model) { vnrequest, error in
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    if results.count > 0 {
                        let topResult = results.first

                        DispatchQueue.main.async {
                            if let confidenceLevel = topResult?.confidence {
                                let confidencePercentage = confidenceLevel * 100
                                if let identifier = topResult?.identifier {
                                    self.resultLabel.text = "\(confidencePercentage)% it's \(identifier)"
                                } else {
                                    self.resultLabel.text = "\(confidencePercentage)%"
                                }
                            } else {
                                self.resultLabel.text = "Unable to determine confidence"
                            }
                        }
                    }
                }
            }

            guard let cgImage = image.cgImage else {
                print("Error converting CIImage to CGImage")
                return
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("Error performing request: \(error)")
                }
            }
        }
    }
}

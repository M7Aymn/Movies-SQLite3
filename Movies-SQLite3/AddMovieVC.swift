//
//  ViewController.swift
//  Day5-Task1
//
//  Created by Mohamed Ayman on 29/07/2024.
//

import UIKit

class AddMovieVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var ref: AddMovieProtocol?
    var imageString = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var ratingTF: UITextField!
    @IBOutlet weak var genreTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addMovieButton(_ sender: UIButton) {
        guard let ref = ref else {return}
        let db = DatabaseManager.shared
        
        let title: String = titleTF.text ?? ""
        let year: Int = Int(yearTF.text ?? "") ?? 0
        let rating: Float = Float(ratingTF.text ?? "") ?? 0.0
//        let image: String = imageTF.text ?? ""
        let genreStatement = genreTF.text ?? ""
        let genre: [String] = genreStatement.components(separatedBy: ",")
        
        if !title.isEmpty {
            db.insert(title: title, image: imageString, rating: rating, releaseYear: year, genre: genre)
            ref.reloadMovies()
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Empty title", message: "Please enter title at least", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func addImageButton(_ sender: UIButton) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imgPicker.sourceType = .photoLibrary
            self.present(imgPicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as! UIImage
        imageView.image = img
        if let imageData = img.pngData() {
            imageString = imageData.base64EncodedString()
        }
        self.dismiss(animated: true)
    }
}


//
//  DetailsViewController.swift
//  Day5-Task1
//
//  Created by Mohamed Ayman on 29/07/2024.
//

import UIKit

class DetailsVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genrelabel: UILabel!
    var movie = Movie(title: "No Movie Name", image: "imageNotFound", rating: 0.0, releaseYear: 0, genre: ["no genre"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    func updateUI() {
        if let dataDecoded = Data(base64Encoded: movie.image) {
            if let img = UIImage(data: dataDecoded) {
                imageView.image = img
            } else {
                imageView.image = UIImage(named: "imageNotFound")!
            }
        } else {
            imageView.image = UIImage(named: "imageNotFound")!
        }
        
        titleLabel.text = movie.title == "" ? "No title" : movie.title
        
        yearLabel.text = movie.releaseYear == 0 ? "No release year" : "\(movie.releaseYear)"
        
        ratingLabel.text = movie.rating == 0.0 ? "No rating" : "\(movie.rating)"
        
        if movie.genre == [""] {
            genrelabel.text = "No genre"
        } else {
            genrelabel.text = ""
            for i in 0..<movie.genre.count {
                genrelabel.text! += movie.genre[i]
                if i < movie.genre.count - 1 {
                    genrelabel.text! += ", "
                }
            }
        }
    }

}

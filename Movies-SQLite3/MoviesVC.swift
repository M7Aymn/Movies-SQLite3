//
//  MoviesVC.swift
//  Day5-Task1
//
//  Created by Mohamed Ayman on 29/07/2024.
//

import UIKit

class MoviesVC: UIViewController, AddMovieProtocol {
    let db = DatabaseManager.shared

    var movies:[Movie] = []

    @IBOutlet weak var moviesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTV.delegate = self
        moviesTV.dataSource = self
        reloadMovies()
    }

}

extension MoviesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension MoviesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTV.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieCell
        
        cell.selectionStyle = .none
        
        cell.titleLabel.text = movies[indexPath.row].title == "" ? "No title" : movies[indexPath.row].title
        
     
        if let dataDecoded = Data(base64Encoded: movies[indexPath.row].image) {
            if let img = UIImage(data: dataDecoded) {
                cell.movieImage.image = img
            } else {
                cell.movieImage.image = UIImage(named: "imageNotFound")!
            }
        } else {
            cell.movieImage.image = UIImage(named: "imageNotFound")!
        }
                    
        cell.ratingLabel.text = movies[indexPath.row].rating == 0.0 ? "No rating" : "rating: \(movies[indexPath.row].rating)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "details") as! DetailsVC
        vc.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadMovies() {
        movies = db.query()
        moviesTV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let title = movies[indexPath.row].title
        db.delete(withTitle: title)
        reloadMovies()
    }
    
    @IBAction func addMovieButton(_ sender: UIBarButtonItem) {
        let addMovieVC = self.storyboard?.instantiateViewController(withIdentifier: "addMovieVC") as! AddMovieVC
        addMovieVC.ref = self
        self.navigationController?.pushViewController(addMovieVC, animated: true)
    }
}

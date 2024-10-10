//
//  DatabaseManager.swift
//  Day5-Task1
//
//  Created by Mohamed Ayman on 29/07/2024.
//

import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    var db: OpaquePointer!
    
    private init() {
        openDatabase()
        createTable()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    let part1DbPath:String? = "test.sqlite"
    
    func openDatabase(){
        let fileManager = FileManager.default
        let directory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Database.sqlite")
        
        if sqlite3_open(directory.path, &db) != SQLITE_OK {
            print("error opening database")
        }
    }
    
    let createTableString = """
    create table Movie(
    title char(255) primary key not null,
    genre char(255),
    image char(255),
    releaseYear int,
    rating float)
    """
    
    func createTable() {
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nMovie table created.")
            } else {
                print("\nMovie table is not created.")
            }
        } else {
            print("\nCREATE TABLE statement is not prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    let insertStatementString = "INSERT INTO Movie (title, genre, image, releaseYear, rating) VALUES (?, ?, ?, ?, ?);"
    
    func insert(title: String, image: String, rating: Float, releaseYear: Int, genre: [String]) {
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) ==
            SQLITE_OK {
            let title: NSString = NSString(string: title)
            let genre: NSString = NSString(string: genreString(genre))
            let image: NSString = NSString(string: image)
            let releaseYear: Int32 = Int32(releaseYear)
            let rating: NSString = NSString(string: "\(rating)")
            
            sqlite3_bind_text(insertStatement, 1, title.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, genre.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, image.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, releaseYear)
            sqlite3_bind_text(insertStatement, 5, rating.utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func genreString(_ genre: [String]) -> String {
        var genreString = ""
        if genre != [""] {
            for i in 0..<genre.count {
                genreString += genre[i]
                if i < genre.count - 1 {
                    genreString += ", "
                }
            }
        }
        return genreString
    }
    
    let queryStatementString = "SELECT * FROM Movie;"
    
    func query() -> [Movie] {
        var queryStatement: OpaquePointer?
        var movies: [Movie] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let title: String = String(cString: sqlite3_column_text(queryStatement, 0))
                var image: String = ""
                var rating: Float = 0.0
                var releaseYear: Int = 0
                var genre: [String] = []
                
                if let genreString = sqlite3_column_text(queryStatement, 1) {
                    genre = String(cString: genreString).components(separatedBy: ",")
                }
                if let imageCString = sqlite3_column_text(queryStatement, 2) {
                    image = String(cString: imageCString)
                }
                let releaseYearInt32 = sqlite3_column_int(queryStatement, 3)
                releaseYear = Int(releaseYearInt32)
                if let ratingCString = sqlite3_column_text(queryStatement, 4) {
                    rating = Float(String(cString: ratingCString)) ?? 0.0
                }
                
                let movie = Movie(title: title, image: image, rating: rating, releaseYear: releaseYear, genre: genre)
                print(movie.title)
                print(movie.image)
                print(movie.rating)
                print(movie.releaseYear)
                print(movie.genre)
                
                movies.append(movie)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        
        return movies
    }
    
    
    let deleteStatementString = "DELETE FROM Movie WHERE title = "
    
    func delete(withTitle title: String) {
        let deleteStatementString = deleteStatementString + "'\(title)';"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted row.")
            } else {
                print("\nCould not delete row.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}

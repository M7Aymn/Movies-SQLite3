//
//  ViewController.swift
//  Day5-Task1
//
//  Created by Mohamed Ayman on 29/07/2024.
//

import UIKit

class ViewController: UIViewController {

    let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "default", style: .default, handler: {action in print("default")}))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "destructive", style: .destructive, handler: nil))
        alert.addTextField(configurationHandler: {textfield in textfield.placeholder = "enter your name"})
//        alert.textFields?.first?.text = "nil"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.present(alert, animated: true)
    }


}


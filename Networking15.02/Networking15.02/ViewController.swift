//
//  ViewController.swift
//  Networking15.02
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var results: [Welcome] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadImage()
    }
    
    func downloadImage() {
        guard let url = URL(string: "https://pixabay.com/api/?key=32828521-f057d7007ce70179fd3955d93&q=yellow+flowers&image_type=photo") else { return }
        let task = URLSession.shared.dataTask(with: url) {  (data, response, error) in
          if error == nil {
            guard let data = data else { return }
            do {
              let model = try JSONDecoder().decode([Welcome].self, from: data)
                self.results = model
                
             } catch let error {
                print("Fucking error")
             }
           }
        }
        task.resume()
    }


}



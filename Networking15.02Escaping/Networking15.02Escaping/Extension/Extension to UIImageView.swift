//
//  Extension to UIImageView.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 23.02.2023.
//

import Foundation
import UIKit

extension UIImageView {
    
    func imageFromURL(urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}

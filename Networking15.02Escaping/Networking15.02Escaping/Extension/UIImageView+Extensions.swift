//
//  Extension to UIImageView.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 23.02.2023.
//

import UIKit

let cache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func imageFromURL(_ urlString: String) {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        } else {
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { [ weak self ] in
                        self?.image = UIImage(data: data)
                        cache.setObject(self?.image ?? UIImage(), forKey: urlString as NSString)
                    }
                }
                task.resume()
            }
        }
    }
}

//
//  Extension to UIImageView.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 23.02.2023.
//

import UIKit

extension UIImageView {
    func imageFromURL(_ urlString: String) {
        let cache = CacheService.shared
        if let cachedImage = cache.returnCachedImage(with: urlString as NSString) {
            self.image = cachedImage
            return
        } else {
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { [ weak self ] in
                        self?.image = UIImage(data: data)
                        CacheService.shared.saveCachedImage(image: self?.image ?? UIImage(), url: urlString as NSString)
                    }
                }
                task.resume()
            }
        }
    }
}

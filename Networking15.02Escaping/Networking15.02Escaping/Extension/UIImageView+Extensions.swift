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
        if let cachedImage = cache.returnCachedImage(with: urlString) {
            self.image = cachedImage
            return
        } else {
            if let url = URL(string: urlString) {
                DispatchQueue.global(qos: .userInitiated).async {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async() { [ weak self ] in
                            guard let self = self else { return }
                            self.image = UIImage(data: data)
                            CacheService.shared.saveCachedImage(image: self.image, url: urlString)
                        }
                    }
                    task.resume()
                }
            }
        }
    }
}

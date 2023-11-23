//
//  CacheService.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 05.09.2023.
//

import UIKit

class CacheService {
    
    //MARK: - Constants
    private struct Constants {
        static let maxElementCount = 100
    }
    static let shared = CacheService()
    
    //MARK: - Private Property
    private var cache = NSCache<NSString, UIImage>()
    private var keys: [String] = []
    private var elementCount = 0
    
    //MARK: - Public Func
    func saveCachedImage(image: UIImage?, url: String) {
        if elementCount >= Constants.maxElementCount {
            clearCache()
        }
        guard let image = image else { return }
        cache.setObject(image, forKey: url as NSString)
        keys.append(url)
        elementCount += 1
    }
    
    func returnCachedImage(with url: String) -> UIImage? {
        cache.object(forKey: url as NSString)
    }
    
    func clearCache() {
        if let firstImage = keys.first {
            cache.removeObject(forKey: firstImage as NSString)
            keys.removeFirst()
        }
    }
}

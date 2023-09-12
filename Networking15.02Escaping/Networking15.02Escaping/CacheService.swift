//
//  CacheService.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 05.09.2023.
//

import UIKit

class CacheService {
    
    static let shared = CacheService()
    
    //MARK: - Private Property
    private var cache = NSCache<NSString, UIImage>()
    private var elementCount = 0
    private var maxElementCount = 100
    
    //MARK: - Public Func
    func saveCachedImage(image: UIImage, url: NSString) {
        cache.setObject(image, forKey: url)
        elementCount += 1
        clearCache()
    }
    
    func returnCachedImage(with url: NSString) -> UIImage? {
        cache.object(forKey: url)
    }
    
    func clearCache() {
        if elementCount >= maxElementCount {
            cache.removeAllObjects()
            elementCount = 0
        }
    }
}

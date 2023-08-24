//
//  FavoriteCellImageModel.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 23.08.2023.
//

import Foundation

struct FavoriteCellImageModel {
    var id: Int
    var url: String
    var isFavorite: Bool
    
    init(id: Int, url: String, isFavorite: Bool) {
        self.id = id
        self.url = url
        self.isFavorite = isFavorite
    }
    
    init(photo: Photo) {
        self.id = Int(photo.id)
        self.url = photo.url ?? ""
        self.isFavorite = photo.isFavorite
    }
}

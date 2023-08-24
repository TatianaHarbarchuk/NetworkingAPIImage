//
//  Model.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import Foundation

// MARK: - Image
struct Image: Codable {
    let total, totalHits: Int
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    var isFavourite: Bool
    var id: Int
    var webformatURL: String
    var imageWidth, imageHeight: Int
    
    enum CodingKeys: String, CodingKey {
        case isFavourite, id, webformatURL, imageWidth, imageHeight
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isFavourite = false
        self.id = try container.decode(Int.self, forKey: .id)
        self.webformatURL = try container.decode(String.self, forKey: .webformatURL)
        self.imageWidth = try container.decode(Int.self, forKey: .imageWidth)
        self.imageHeight = try container.decode(Int.self, forKey: .imageHeight)
    }
}


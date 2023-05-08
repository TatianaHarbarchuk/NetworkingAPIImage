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
    var isFavourite: Bool?
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let previewWidth, previewHeight: Int
    let webformatURL: String
    let webformatWidth, webformatHeight: Int
    let largeImageURL: String
    let imageWidth, imageHeight, imageSize, views: Int
    let downloads, collections, likes, comments: Int
    let userID: Int
    let user: String
    let userImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case isFavourite, id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, collections, likes, comments
        case userID = "user_id"
        case user, userImageURL
    }
}


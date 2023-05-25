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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isFavourite = false
        self.id = try container.decode(Int.self, forKey: .id)
        self.pageURL = try container.decode(String.self, forKey: .pageURL)
        self.type = try container.decode(String.self, forKey: .type)
        self.tags = try container.decode(String.self, forKey: .tags)
        self.previewURL = try container.decode(String.self, forKey: .previewURL)
        self.previewWidth = try container.decode(Int.self, forKey: .previewWidth)
        self.previewHeight = try container.decode(Int.self, forKey: .previewHeight)
        self.webformatURL = try container.decode(String.self, forKey: .webformatURL)
        self.webformatWidth = try container.decode(Int.self, forKey: .webformatWidth)
        self.webformatHeight = try container.decode(Int.self, forKey: .webformatHeight)
        self.largeImageURL = try container.decode(String.self, forKey: .largeImageURL)
        self.imageWidth = try container.decode(Int.self, forKey: .imageWidth)
        self.imageHeight = try container.decode(Int.self, forKey: .imageHeight)
        self.imageSize = try container.decode(Int.self, forKey: .imageSize)
        self.views = try container.decode(Int.self, forKey: .views)
        self.downloads = try container.decode(Int.self, forKey: .downloads)
        self.collections = try container.decode(Int.self, forKey: .collections)
        self.likes = try container.decode(Int.self, forKey: .likes)
        self.comments = try container.decode(Int.self, forKey: .comments)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.user = try container.decode(String.self, forKey: .user)
        self.userImageURL = try container.decode(String.self, forKey: .userImageURL)
    }
}


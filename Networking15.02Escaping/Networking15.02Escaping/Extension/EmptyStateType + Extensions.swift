//
//  ImageListController.EmptyViewImages + Extensions.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 04.04.2023.
//

import Foundation
import UIKit

//MARK: - Enum EmptyViewImages
enum EmptyStateType {
    case notExistingImages
    case noImagesAtAll
}

extension EmptyStateType: EmptyViewProtocol {
    
    var image: UIImage {
        switch self {
        case .notExistingImages:
            return UIImage(named: "No images found") ?? UIImage()
        case .noImagesAtAll:
            return UIImage(named: "Please enter text") ?? UIImage()
        }
    }
    
    var message: String {
        switch self {
        case .notExistingImages:
            return "No images found"
        case .noImagesAtAll:
            return "Please enter text..."
        }
    }
}

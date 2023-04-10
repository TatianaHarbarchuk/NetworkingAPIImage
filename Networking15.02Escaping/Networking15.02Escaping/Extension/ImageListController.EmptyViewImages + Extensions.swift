//
//  ImageListController.EmptyViewImages + Extensions.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 04.04.2023.
//

import Foundation
import UIKit

extension ImageListController.EmptyViewImages: EmptyViewProtocol {
    var emptyImageView: UIImageView {
        switch self {
        case .notExistingImages:
            return UIImageView(image: UIImage(named: "6134065"))
        case .noImagesAtAll:
            return UIImageView(image: UIImage(named: "Please enter text"))
        }
    }
    
    var emptyText: String {
        switch self {
        case .notExistingImages:
            return "No images found"
        case .noImagesAtAll:
            return "Please enter text..."
        }
    }
}

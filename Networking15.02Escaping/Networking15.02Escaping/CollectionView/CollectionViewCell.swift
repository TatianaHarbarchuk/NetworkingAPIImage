//
//  CollectionViewCell.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 12.06.2023.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func isFavouriteDidChange(for imageURL: String, _ isFavourite: Bool)
}

final class CollectionViewCell: UICollectionViewCell {
    
    //MARK: - Constants
    private struct Constants {
        static let size: CGFloat = 36
        static let cornerRadius: CGFloat = 10
    }
    //MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView?
    
    //MARK: - Properties
    private var fetchedImage: Hit?
    weak var delegate: CollectionViewCellDelegate?
    
    //MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        fetchedImage = nil
    }
    
    //MARK: - Func configureWith
    func configureWith(model: Hit) {
        imageView?.imageFromURL(model.webformatURL)
        fetchedImage = model
    }
}

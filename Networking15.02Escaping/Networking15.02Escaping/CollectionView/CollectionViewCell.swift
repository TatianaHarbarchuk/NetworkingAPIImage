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

class CollectionViewCell: UICollectionViewCell {
    
    //MARK: - Constants
    private struct Constants {
        static let size: CGFloat = 36
        static let cornerRadius: CGFloat = 10
    }
    //MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView?
    
    //MARK: - Properties
    private var fetchedImage: Hit?
    private var likeButton = UIButton(type: .custom)
    weak var delegate: CollectionViewCellDelegate?
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        fetchedImage = nil
    }
    
    //MARK: - Func configureWith
    func configureWith(model: Hit) {
        imageView?.imageFromURL(model.webformatURL)
        fetchedImage = model
        likeButton.tintColor = model.isFavourite  ? .systemRed : .lightGray
    }
    
    //    private func setup() {
    //        imageView.map { imgVW in
    //            imgVW.translatesAutoresizingMaskIntoConstraints = false
    //            imgVW.clipsToBounds = true
    //            imgVW.layer.cornerRadius = Constants.cornerRadius
    //        }
    //        likeButton.translatesAutoresizingMaskIntoConstraints = false
    //        addSubview(likeButton)
    //        NSLayoutConstraint.activate([
    //            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
    //            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
    //            likeButton.widthAnchor.constraint(equalToConstant: Constants.size),
    //            likeButton.heightAnchor.constraint(equalToConstant: Constants.size)
    //        ])
    //        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    //        likeButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    //}
    
    //    @objc private func favouriteButtonPressed(_ sender: UIButton) {
    //        fetchedImage?.isFavourite.toggle()
    //        guard let fetchedImages = fetchedImage else {
    //            return
    //        }
    //        delegate?.isFavouriteDidChange(for: fetchedImages.webformatURL, fetchedImages.isFavourite)
    //    }
}

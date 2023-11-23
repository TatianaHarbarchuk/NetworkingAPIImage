//
//  FavouriteImageCell.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 01.08.2023.
//

import UIKit

final class FavoriteImageCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private var imgView: UIImageView?
    
    //MARK: - Properties
    private var fetchedImage: FavoriteCellImageModel?
    private var likeButton = UIButton(type: .custom)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView?.image = nil
        fetchedImage = nil
    }
    
    private func setup() {
        imgView = imgView.map({ imageView in
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            imageView.contentMode = .bottomRight
            imageView.layer.cornerRadius = 10
            return imageView
        })
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 36),
            likeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .systemRed
        likeButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    
    func configureWith(model: FavoriteCellImageModel) {
            imgView?.imageFromURL(model.url)
            fetchedImage = model
    }
    
    @objc private func favouriteButtonPressed(_ sender: UIButton) {
        FavoriteImageService.shared.deleteImage(with: fetchedImage?.id ?? 0)
    }
}

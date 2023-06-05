//
//  TableViewCell.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 17.02.2023.
//

import UIKit

protocol MainImageCellDelegate: AnyObject {
    func isFavouriteDidChange(for imageURL: String, _ isFavourite: Bool)
}

final class MainImageCell: UITableViewCell {
    
    private struct Constants {
        static let cornerRadius: CGFloat = 64
    }
    
    //MARK: - IBOutlets
    @IBOutlet private var imageVW: UIImageView?
    
    //MARK: - Properties
    private var likeButton = UIButton(type: .custom)
    private var fetchedImage: Hit?
    weak var delegate: MainImageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageVW?.image = nil
        fetchedImage = nil
    }
    
    //MARK: - Configure with model
    func configureWith(model: Hit) {
        imageVW?.imageFromURL(model.webformatURL)
        fetchedImage = model
        likeButton.tintColor = model.isFavourite  ? .systemRed : .lightGray
    }
    
    //MARK: - Setup func
    private func setup() {
        imageVW = imageVW.map({ imageView in
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            imageView.contentMode = .bottomRight
            imageView.layer.cornerRadius = Constants.cornerRadius
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
        likeButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        
    }
    
    @objc private func favouriteButtonPressed(_ sender: UIButton) {
        fetchedImage?.isFavourite.toggle()
        guard let fetchedImages = fetchedImage else {
            return
        }
        delegate?.isFavouriteDidChange(for: fetchedImages.webformatURL, fetchedImages.isFavourite)
    }
}


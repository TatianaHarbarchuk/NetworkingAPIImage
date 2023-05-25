//
//  TableViewCell.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 17.02.2023.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func isFavouriteDidChange(for imageURL: String, _ isFavourite: Bool)
}

class TableViewCell: UITableViewCell {
    
    private struct Constants {
        static let cornerRadius: CGFloat = 64
    }
    
    //MARK: - IBOutlets
    @IBOutlet private var imageVCell: UIImageView?
    
    //MARK: - Properties
    private var likeButton = UIButton(type: .custom)
    private var fetchedImages: Hit?
    private var imageId: Int?
    weak var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageVCell?.image = nil
        fetchedImages = nil
    }
    
    //MARK: - Configure with model
    func configureWith(model: Hit) {
        imageVCell?.imageFromURL(model.webformatURL)
        imageId = model.id
        fetchedImages = model
        likeButton.tintColor = model.isFavourite  ? .systemRed : .lightGray
    }
    
    //MARK: - Setup func
    private func setup() {
        imageVCell?.translatesAutoresizingMaskIntoConstraints = false
        imageVCell?.contentMode = .scaleToFill
        imageVCell?.clipsToBounds = true
        imageVCell?.contentMode = .bottomRight
        imageVCell?.layer.cornerRadius = Constants.cornerRadius
        likeButton.frame = CGRect(x: 310, y: 300, width: 120, height: 120)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        addSubview(likeButton)
    }
    
    @objc private func favouriteButtonPressed(_ sender: UIButton) {
        fetchedImages?.isFavourite.toggle()
        guard let fetchedImages = fetchedImages else {
            return
        }
        delegate?.isFavouriteDidChange(for: fetchedImages.webformatURL, fetchedImages.isFavourite)
    }
}


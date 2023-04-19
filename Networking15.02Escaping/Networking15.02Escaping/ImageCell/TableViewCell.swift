//
//  TableViewCell.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 17.02.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    private struct Constants {
        static let cornerRadius: CGFloat = 64
    }
    
    @IBOutlet private weak var imageViewCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    override func prepareForReuse() {
        imageViewCell.image = nil
    }
    
    //MARK: - Configure with model
    func configureWith(model webformatURL: String) {
        imageViewCell.imageFromURL(webformatURL)
    }
    //MARK: - Setup func
    private func setup() {
        imageViewCell.translatesAutoresizingMaskIntoConstraints = false
        imageViewCell.contentMode = .scaleToFill
        imageViewCell.clipsToBounds = true
        imageViewCell.contentMode = .bottomRight
        imageViewCell.layer.cornerRadius = Constants.cornerRadius
    }
}

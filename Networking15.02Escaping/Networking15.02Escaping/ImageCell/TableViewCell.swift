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
    
    @IBOutlet private var imageVCell: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageVCell?.image = nil
    }
    
    //MARK: - Configure with model
    func configureWith(model webformatURL: String) {
        imageVCell?.imageFromURL(webformatURL)
    }
    //MARK: - Setup func
    private func setup() {
        imageVCell?.translatesAutoresizingMaskIntoConstraints = false
        imageVCell?.contentMode = .scaleToFill
        imageVCell?.clipsToBounds = true
        imageVCell?.contentMode = .bottomRight
        imageVCell?.layer.cornerRadius = Constants.cornerRadius
    }
}

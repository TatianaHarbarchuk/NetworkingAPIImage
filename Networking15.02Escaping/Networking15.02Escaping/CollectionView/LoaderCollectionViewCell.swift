//
//  LoaderCollectionViewCell.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 12.06.2023.
//

import UIKit

class LoaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator?.startAnimating()
    }
}

//
//  LoadingTableViewCell.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 18.04.2023.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet private var loader: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loader?.startAnimating()
    }
}

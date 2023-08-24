//
//  UICollectionView+Extensions.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 12.06.2023.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(with cellType: T.Type) {
        register(UINib(nibName: String(describing: cellType), bundle: nil), forCellWithReuseIdentifier: String(describing: cellType))
    }
}

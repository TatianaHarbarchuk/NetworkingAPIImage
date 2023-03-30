//
//  UITableView+Extensions.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 30.03.2023.
//

import Foundation
import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(with cellType: T.Type) {
        register(UINib(nibName: String(describing: cellType), bundle: nil), forCellReuseIdentifier: String(describing: cellType))
    }
}

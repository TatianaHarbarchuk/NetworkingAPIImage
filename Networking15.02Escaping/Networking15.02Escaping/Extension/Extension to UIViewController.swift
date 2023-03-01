//
//  Extension to UIViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 23.02.2023.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images?.hits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell {
            guard let image = images?.hits else { return cell }
            cell.imageViewCell.imageFromURL(urlString: image[indexPath.row].webformatURL)
            cell.titleLabel?.text = String(image[indexPath.row].id)
            cell.imageViewCell.translatesAutoresizingMaskIntoConstraints = false
            cell.imageViewCell.contentMode = .scaleAspectFit
            cell.imageViewCell.clipsToBounds = true
            cell.imageViewCell.contentMode = .bottomRight
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
}


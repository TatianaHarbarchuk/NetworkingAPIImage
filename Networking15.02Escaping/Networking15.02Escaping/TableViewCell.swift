//
//  TableViewCell.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 17.02.2023.
//

import UIKit

//MARK: - висота ячейки залежить від методу делегата heighForRawIndexPAth
//MARK: - ширина ячейки залежить від ширини таблиці 

class TableViewCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

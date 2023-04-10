//
//  EmptyStateView.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 17.03.2023.
//

import Foundation
import UIKit

class EmptyStateView: UIView {
    
    var messageLabel = UILabel()
    var emptyStateImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmptyView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupEmptyView()
    }
    
    //MARK: - setupEmptyView
    private func setupEmptyView() {
        backgroundColor = .clear
        messageLabel.textAlignment = .center
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.contentMode = .scaleToFill
        addSubview(messageLabel)
        addSubview(emptyStateImageView)
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor),
            emptyStateImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 130),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    //MARK: - setMessage
    func setMessage(_ emptyMessage: String, emptyImage: UIImageView) {
        messageLabel.text = emptyMessage
        emptyStateImageView.image = emptyImage.image
    }
}

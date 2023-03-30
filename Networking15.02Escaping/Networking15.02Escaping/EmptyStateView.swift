//
//  EmptyStateView.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 17.03.2023.
//

import Foundation
import UIKit

class EmptyStateView: UIView {
    
    private var messageLabel = UILabel()
    
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
        addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

    //MARK: - setMessage
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
}

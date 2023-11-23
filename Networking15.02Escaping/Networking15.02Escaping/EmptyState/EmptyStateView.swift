//
//  EmptyStateView.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 17.03.2023.
//

import Foundation
import UIKit

final class EmptyStateView: UIView {
    
    private struct Constants {
        static let centerYAnchor: CGFloat = -100
        static let constraint: CGFloat = 100
    }
    
    private let message = UILabel()
    private var imageView = UIImageView()
    
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
        message.textAlignment = .center
        message.textColor = .black
        message.font = UIFont.systemFont(ofSize: 18)
        message.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        addSubview(message)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            message.bottomAnchor.constraint(equalTo: bottomAnchor),
            message.trailingAnchor.constraint(equalTo: trailingAnchor),
            message.leadingAnchor.constraint(equalTo: leadingAnchor),
            message.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constants.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.constraint),
            imageView.heightAnchor.constraint(equalToConstant: Constants.constraint)
        ])
    }
    
    //MARK: - setWithModel
    func set(with model: EmptyViewProtocol) {
        message.text = model.message
        imageView.image = model.image
    }
}

//
//  ImageViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 06.05.2023.
//

import UIKit

protocol ImageViewControllerDelegate: AnyObject {
    func didTapLikeButton(url: String, isFavourite: Bool)
}

final class ImageViewController: UIViewController {
    
    private struct Constants {
        static let indicatorSize: CGFloat = 40
        static let cornerRadius: CGFloat = 30
        static let buttonSize: CGFloat = 36
    }
    
    //MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView?
    
    //MARK: - Properties
    private var imageURL: String?
    private var likeButton = UIButton(type: .custom)
    var fetchedImage: Hit? {
        didSet {
            likeButton.tintColor = fetchedImage?.isFavourite ?? false ? .systemRed : .lightGray
            delegate?.didTapLikeButton(url: fetchedImage?.webformatURL ?? "", isFavourite: fetchedImage?.isFavourite ?? false)
        }
    }
    weak var delegate: ImageViewControllerDelegate?
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadImage()
        configureButton()
    }
    
    //MARK: - Func loadImage
    private func loadImage() {
        activityIndicator.startAnimating()
        if let imageURL = fetchedImage?.webformatURL {
            imageView?.imageFromURL(imageURL)
        }
        activityIndicator.stopAnimating()
    }
    
    //MARK: - Func setup
    private func setup() {
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.layer.cornerRadius = Constants.cornerRadius
        imageView?.contentMode = .scaleAspectFill
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: Constants.indicatorSize, height: Constants.indicatorSize))
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        view.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.bottomAnchor.constraint(equalTo: imageView?.bottomAnchor ?? view.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? view.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
        ])
    }
    
    //MARK: - Func configureButton
    private func configureButton() {
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = fetchedImage?.isFavourite ?? false ? .systemRed : .lightGray
        likeButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    
    @objc private func favouriteButtonPressed(_ sender: UIButton) {
        guard fetchedImage?.isFavourite != nil else {
            fetchedImage?.isFavourite = true
            return
        }
        fetchedImage?.isFavourite.toggle()
    }
}





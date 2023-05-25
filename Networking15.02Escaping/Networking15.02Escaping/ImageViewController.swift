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

class ImageViewController: UIViewController {
    
    private struct Constants {
        static let indicatorSize: CGFloat = 40
        static let cornerRadius: CGFloat = 30
    }
    
    //MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView?
    
    //MARK: - Properties
    private var imageURL: String?
    private var likeButton = UIButton(type: .custom)
    var fetchedImages: Hit? {
        didSet {
            likeButton.tintColor = fetchedImages?.isFavourite ?? false ? .systemRed : .lightGray
            delegate?.didTapLikeButton(url: fetchedImages?.webformatURL ?? "", isFavourite: fetchedImages?.isFavourite ?? false)
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
        if let imageURL = fetchedImages?.webformatURL {
            imageView?.imageFromURL(imageURL)
        }
        activityIndicator.stopAnimating()
    }
    
    //MARK: - Func setup
    private func setup() {
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.layer.cornerRadius = Constants.cornerRadius
        imageView?.contentMode = .scaleAspectFill
        likeButton.frame = CGRect(x: 300, y: 490, width: 120, height: 120)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: Constants.indicatorSize, height: Constants.indicatorSize))
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        view.addSubview(likeButton)
    }
    
    //MARK: - Func configureButton
    private func configureButton() {
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = fetchedImages?.isFavourite ?? false ? .systemRed : .lightGray
        likeButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    
    @objc private func favouriteButtonPressed(_ sender: UIButton) {
        guard fetchedImages?.isFavourite != nil else {
            fetchedImages?.isFavourite = true
            return
        }
        fetchedImages?.isFavourite.toggle()
    }
}





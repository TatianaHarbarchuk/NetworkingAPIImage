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
    @IBOutlet var imageScrollView: UIScrollView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImage()
        configureButton()
        configureScrollView()
        setup()
    }
    
    func configureScrollView() {
        imageScrollView?.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageScrollView?.backgroundColor = .clear
        imageScrollView?.delegate = self
        view.addSubview(imageScrollView ?? view)
        if let imageView = imageView {
            imageScrollView?.addSubview(imageView)
        }
        imageScrollView?.maximumZoomScale = 3.0
        imageScrollView?.minimumZoomScale = 1.0
        imageScrollView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView?.topAnchor.constraint(equalTo: imageScrollView?.topAnchor ?? view.topAnchor, constant: 100).isActive = true
        imageView?.leadingAnchor.constraint(equalTo: imageScrollView?.leadingAnchor ?? view.leadingAnchor, constant: 20).isActive = true
        imageView?.bottomAnchor.constraint(equalTo: imageScrollView?.bottomAnchor ?? view.bottomAnchor).isActive = true
        imageView?.widthAnchor.constraint(equalToConstant: 350).isActive = true
        imageView?.heightAnchor.constraint(equalToConstant: 500).isActive = true
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
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: Constants.indicatorSize, height: Constants.indicatorSize))
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    //MARK: - Func configureButton
    private func configureButton() {
        let likeBarButtonItem = UIBarButtonItem(customView: likeButton)
        navigationItem.rightBarButtonItem = likeBarButtonItem
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

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}





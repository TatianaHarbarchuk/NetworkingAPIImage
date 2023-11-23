//
//  ImageViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 06.05.2023.
//

import UIKit

final class ImageViewController: UIViewController {
    
    //MARK: - Constants
    private struct Constants {
        static let indicatorSize: CGFloat = 40
        static let cornerRadius: CGFloat = 30
        static let buttonSize: CGFloat = 36
    }
    
    //MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var imageScrollView: UIScrollView?
    
    //MARK: - Properties
    private var likeButton = UIButton(type: .custom)
    var image: Hit?
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    private var saveButton = UIButton(type: .custom)
    private var imageLoader = ImageLoader()
    private var shareButton = UIButton(type: .custom)
    private var isFavorite = false {
        didSet {
            likeButton.tintColor = isFavorite ? .systemRed : .lightGray
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FavoriteImageService.shared.load()
        loadImage()
        configureButton()
        configureScrollView()
        setup()
        tabBarController?.tabBar.isHidden = true
        if let id = image?.id {
            isFavorite = FavoriteImageService.shared.isFavoriteImage(id: id)
        }
    }
    
    //MARK: - Func configureScrollView
    private func configureScrollView() {
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
        let constraints: [NSLayoutConstraint] = [
            imageScrollView?.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView?.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageScrollView?.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageScrollView?.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView?.topAnchor.constraint(equalTo: imageScrollView?.topAnchor ?? view.topAnchor, constant: 100),
            imageView?.leadingAnchor.constraint(equalTo: imageScrollView?.leadingAnchor ?? view.leadingAnchor, constant: 20),
            imageView?.bottomAnchor.constraint(equalTo: imageScrollView?.bottomAnchor ?? view.bottomAnchor),
            imageView?.widthAnchor.constraint(equalToConstant: 350),
            imageView?.heightAnchor.constraint(equalToConstant: 500)
        ].compactMap { $0 }
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Func loadImage
    private func loadImage() {
        activityIndicator.startAnimating()
        if let imageURL = image?.webformatURL {
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
        let shareBarButtonItem = UIBarButtonItem(customView: shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .lightGray
        shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        saveButton.tintColor = .lightGray
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        let likeBarButtonItem = UIBarButtonItem(customView: likeButton)
        navigationItem.rightBarButtonItems = [likeBarButtonItem, saveBarButtonItem, shareBarButtonItem]
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    
    @objc private func favouriteButtonPressed(_ sender: UIButton) {
        isFavorite = !isFavorite
        guard let image = image else { return }
        if isFavorite {
            FavoriteImageService.shared.saveFavoriteImages(model: image)
        } else if FavoriteImageService.shared.isFavoriteImage(id: image.id){
            FavoriteImageService.shared.deleteImage(with: image.id)
        }
    }
    
    @objc private func saveButtonPressed() {
        guard let image = imageView?.image else { return }
        imageLoader.delegate = self
        imageLoader.download(image: image)
    }
    
    @objc private func shareButtonPressed() {
        guard let image = imageView?.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true)
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ImageViewController: ImageSaverDelegate {
    func isSuccessDownload() {
        let alertController = UIAlertController(title: "Success!", message: "Images have been successfully added to your gallery", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    func isFailedDownload() {
        let alertController = UIAlertController(title: "Failed!", message: "Images haven't been added to your gallery", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}

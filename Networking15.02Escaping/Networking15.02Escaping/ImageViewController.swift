//
//  ImageViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 06.05.2023.
//

import UIKit

//protocol ImageViewControllerDelegate: AnyObject {
//    func didTapLikeButton(url: String, isFavourite: Bool)
//}

protocol ImageViewControllerDelegate: AnyObject {
    func  returnImageAsFavorite(with id: Int)
}

final class ImageViewController: UIViewController {
    
    //MARK: - Constants
    private struct Constants {
        static let indicatorSize: CGFloat = 40
        static let cornerRadius: CGFloat = 30
        static let buttonSize: CGFloat = 36
    }
    
    //MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet var imageScrollView: UIScrollView?
    
    //MARK: - Properties
    weak var delegate: ImageViewControllerDelegate?
    private var imageURL: String?
    private var likeButton = UIButton(type: .custom)
    var fetchedImage: Hit? {
        didSet {
            likeButton.tintColor = fetchedImage?.isFavourite ?? false ? .systemRed : .lightGray
//            delegate?.didTapLikeButton(url: fetchedImage?.webformatURL ?? "", isFavourite: fetchedImage?.isFavourite ?? false)
            delegate?.returnImageAsFavorite(with: fetchedImage?.id ?? 0)
        }
    }
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    private var saveButton = UIButton(type: .custom)
    private var imageSaver = ImageSaver()
    private var shareButton = UIButton(type: .custom)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FavoriteImageHelper.shared.load()
        loadImage()
        configureButton()
        configureScrollView()
        setup()
        tabBarController?.tabBar.isHidden = true
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
        likeButton.tintColor = fetchedImage?.isFavourite ?? false ? .systemRed : .lightGray
        likeButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    
    @objc private func favouriteButtonPressed(_ sender: UIButton) {
        guard fetchedImage?.isFavourite != nil else {
            fetchedImage?.isFavourite = true
            return
        }
        fetchedImage?.isFavourite.toggle()
        guard var isFavorite = fetchedImage?.isFavourite else { return }
        if isFavorite {
            guard let fetchedImage = fetchedImage else { return }
            FavoriteImageHelper.shared.saveFavoriteImages(model: fetchedImage)
        } else if FavoriteImageHelper.shared.isFavoriteImage(id: fetchedImage?.id ?? 0){
            FavoriteImageHelper.shared.deleteImage(with: fetchedImage?.id ?? 0)
        }
    }
    
    @objc private func saveButtonPressed() {
        guard let image = imageView?.image else { return }
        imageSaver.delegate = self
        imageSaver.download(image: image)
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
    func isSuccessdownload() {
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





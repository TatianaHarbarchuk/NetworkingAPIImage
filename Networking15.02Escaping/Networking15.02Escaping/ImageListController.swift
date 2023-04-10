//
//  ViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit

class ImageListController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    //MARK: - Constants
    struct Constants {
        static let indicatorSize: CGFloat = 40
        static let text = ""
        static let imagesPerPage = 30
    }
    
    //MARK: - @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    private var fetchedImages: [Hit] = []
    private let emptyStateView = EmptyStateView(frame: .zero)
    private let imageService = ImageService()
    private var searchTextField = UITextField()
    private var indicator = UIActivityIndicatorView(style: .medium)
    private var currentPage = 1
    private var isLoading = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
        setupEmptyStateView()
        setupGestureRecognizer()
    }
    
    //MARK: - Setup Gesture Recognizer
    private func setupGestureRecognizer() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - setupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(with: TableViewCell.self)
        view.addSubview(emptyStateView)
        createActivityIndicator()
    }
    
    //MARK: - setupSearchBar
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = .search
    }
    
    //MARK: - setupEmptyStateView
    private func setupEmptyStateView() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.setMessage(ImageListController.EmptyViewImages.noImagesAtAll.emptyText, emptyImage: ImageListController.EmptyViewImages.noImagesAtAll.emptyImageView)
        NSLayoutConstraint.activate([
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
    }
    
    //MARK: - createActivityIndicator
    private func createActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: .zero, y: .zero, width: Constants.indicatorSize, height: Constants.indicatorSize))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
    }
    
    //MARK: - Load Images
    private func loadImages(matching searchText: String) {
        indicator.startAnimating()
        imageService.fetchingAPIImages(matching: searchText, perPage: Constants.imagesPerPage, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.fetchedImages = result
            DispatchQueue.main.async {
                if self.fetchedImages.isEmpty {
                    self.showEmptyView(withImages: .notExistingImages)
                } else {
                    self.emptyStateView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
                self.indicator.stopAnimating()
            }
        }
    }
    
    //MARK: - Func loadMoreImages
    func loadMoreImages() {
        isLoading = true
        indicator.startAnimating()
        imageService.fetchingAPIImages(matching: Constants.text, perPage: Constants.imagesPerPage, page: currentPage) { result in
            self.fetchedImages.append(contentsOf: result)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.isLoading = false
            }
        }
        indicator.stopAnimating()
    }
    
    //MARK: - Enum EmptyViewImages
    enum EmptyViewImages  {
        case notExistingImages
        case noImagesAtAll
    }
    
    //MARK: - Func showEmptyView
    private func showEmptyView(withImages images: ImageListController.EmptyViewImages) {
        switch images {
        case .notExistingImages:
            tableView.reloadData()
            fetchedImages = []
            emptyStateView.emptyStateImageView.image = images.emptyImageView.image
            emptyStateView.messageLabel.text = images.emptyText
        case .noImagesAtAll:
            fetchedImages = []
            tableView.reloadData()
            emptyStateView.emptyStateImageView.image = images.emptyImageView.image
            emptyStateView.messageLabel.text = images.emptyText
        }
        emptyStateView.isHidden = false
    }
    
    //MARK: - Func searchBarSearchButtonClicked
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.isEmpty {
            showEmptyView(withImages: .noImagesAtAll)
        } else  {
            self.tableView.isHidden = false
            self.emptyStateView.isHidden = true
            loadImages(matching: searchBarText)
        }
        searchBar.resignFirstResponder()
    }
    
    //MARK: - Func searchBarCancelButtonClicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: - Func textFieldShouldClear
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchBar.searchTextField.clearButtonMode = .whileEditing
        showEmptyView(withImages: .noImagesAtAll)
        return true
    }
}

extension ImageListController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    //MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedImages.count
    }
    
    //MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as? TableViewCell {
            let image = fetchedImages
            cell.configureWith(model: image[indexPath.row].webformatURL)
            
            return cell
        }
        return UITableViewCell()
    }
    
    //MARK: - willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastImage = fetchedImages.count - 1
        if indexPath.row == lastImage && !isLoading {
            currentPage += 1
            loadMoreImages()
        }
    }
    
    //MARK: - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    //MARK: - scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableViewHeight = tableView.frame.size.height
        let contentHeight = tableView.contentSize.height
        let contentOffset = tableView.contentOffset.y
        
        if contentOffset + tableViewHeight >= contentHeight {
            if !isLoading {
                currentPage += 1
                loadMoreImages()
            }
        }
    }
}

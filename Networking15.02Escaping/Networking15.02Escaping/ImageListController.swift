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
        static let heightCell: CGFloat = 60
    }
    
    //MARK: - @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    private var fetchedImages: [Hit] = []
    private let emptyStateView = EmptyStateView(frame: .zero)
    private let imageService = ImageService()
    private let EmptyViewEnum = ImageListController.EmptyViewImages.self
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
        tableView.register(with: LoadingTableViewCell.self)
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
        emptyStateView.set(with: ImageListController.EmptyViewImages.noImagesAtAll)
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
        imageService.fetchingAPIImages(matching: searchText, perPage: Constants.imagesPerPage, page: currentPage) { [weak self] result,error  in
            guard let self = self else { return }
            self.isLoading = false
            self.fetchedImages = result
            DispatchQueue.main.async {
                if self.fetchedImages.isEmpty {
                    self.showEmptyView(with: .notExistingImages)
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
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        imageService.fetchingAPIImages(matching: Constants.text, perPage: Constants.imagesPerPage, page: currentPage) { result,error  in
            self.fetchedImages.append(contentsOf: result)
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    //MARK: - Enum EmptyViewImages
    enum EmptyViewImages  {
        case notExistingImages
        case noImagesAtAll
    }
    
    //MARK: - Func showEmptyView
    private func showEmptyView(with images: ImageListController.EmptyViewImages) {
        switch images {
        case .notExistingImages:
            fetchedImages = []
            tableView.reloadData()
            emptyStateView.set(with: images)
        case .noImagesAtAll:
            tableView.reloadData()
            fetchedImages = []
            emptyStateView.set(with: images)
        }
        emptyStateView.isHidden = false
    }
    
    //MARK: - Func searchBarSearchButtonClicked
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.isEmpty {
            showEmptyView(with: .noImagesAtAll)
        } else  {
            self.tableView.isHidden = false
            self.emptyStateView.isHidden = true
            currentPage = 0
            currentPage += 1
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
        showEmptyView(with: .noImagesAtAll)
        fetchedImages = []
        tableView.reloadData()
        return true
    }
}

extension ImageListController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    //MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return fetchedImages.count
        } else if section == 1 && isLoading {
            return 1
        }
        return 0
    }
    
    //MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
            let image = fetchedImages
            cell.configureWith(model: image[indexPath.row].webformatURL)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingTableViewCell.self), for: indexPath) as! LoadingTableViewCell
            cell.loader.startAnimating()
            
            return cell
        }
    }
    
    //MARK: - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UIScreen.main.bounds.width
        } else {
            return Constants.heightCell
        }
    }
    
    //MARK: - scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height && !isLoading {
            currentPage += 1
            loadMoreImages()
            
        }
    }
}

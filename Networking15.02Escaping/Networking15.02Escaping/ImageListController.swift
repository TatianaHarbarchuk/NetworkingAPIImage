//
//  ViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit

class ImageListController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    //MARK: - Constants
    private struct Constants {
        static let indicatorSize: CGFloat = 40
        static let heightCell: CGFloat = 60
    }
    
    //MARK: - @IBOutlet
    @IBOutlet private var tableView: UITableView?
    
    //MARK: - Properties
    private var fetchedImages: [Hit] = []
    private let emptyStateView = EmptyStateView(frame: .zero)
    private let imageService = ImageService()
    private let searchTextField = UITextField()
    private var indicator = UIActivityIndicatorView(style: .medium)
    private var currentPage = 1
    private var isLoading = false
    private var isLastPage = false
    private var searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        setupTableView()
        setupEmptyStateView()
        setupGestureRecognizer()
        setupSearchController()
    }
    //MARK: - setupSearchController
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.searchTextField.delegate = self
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
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(with: TableViewCell.self)
        tableView?.register(with: LoadingTableViewCell.self)
        view.addSubview(emptyStateView)
        createActivityIndicator()
    }
    
    //MARK: - setupEmptyStateView
    private func setupEmptyStateView() {
        print("setupEmptyStateView")
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.set(with: EmptyStateType.noImagesAtAll)
        NSLayoutConstraint.activate([
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    //MARK: - createActivityIndicator
    private func createActivityIndicator() {
        print("createActivityIndicator")
        indicator = UIActivityIndicatorView(frame: CGRect(x: .zero, y: .zero, width: Constants.indicatorSize, height: Constants.indicatorSize))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView?.center ?? view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
    }
    
    //MARK: - Load Images
    private func loadImages(matching searchText: String) {
        print("loadImages")
        isLastPage = false
        indicator.startAnimating()
        imageService.fetchingAPIImages(matching: searchText, page: currentPage) { [weak self] result,error  in
            guard let self = self else { return }
            self.isLoading = false
            self.fetchedImages = result
            
            if result.count < 30 {
                self.isLastPage = true
            }
            
            DispatchQueue.main.async {
                if self.fetchedImages.isEmpty {
                    self.showEmptyView(with: .notExistingImages)
                } else {
                    print("No empty")
                    self.emptyStateView.isHidden = true
                    self.tableView?.isHidden = false
                    self.tableView?.reloadData()
                }
                self.indicator.stopAnimating()
            }
        }
    }
    
    //MARK: - Func loadMoreImages
    func loadMoreImages() {
        isLoading = true
        imageService.fetchingAPIImages(matching: searchController.searchBar.text ?? "", page: currentPage) { result,error  in
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    if result.count < 30 {
                        self.isLastPage = true
                    }
                    
                    self.fetchedImages.append(contentsOf: result)
                    self.tableView?.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    //MARK: - Func reloadTableView
    private func reloadTableView() {
        fetchedImages = []
        tableView?.reloadData()
    }
    
    //MARK: - Func showEmptyView
    private func showEmptyView(with images: EmptyStateType) {
        print("showEmptyView")
        reloadTableView()
        emptyStateView.set(with: images)
        emptyStateView.isHidden = false
    }
    
    //MARK: - Func searchBarSearchButtonClicked
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        guard let searchBarText = searchController.searchBar.text else { return }
        if searchBarText.isEmpty {
            showEmptyView(with: .noImagesAtAll)
        } else  {
            self.tableView?.isHidden = false
            self.emptyStateView.isHidden = true
            currentPage = 1
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
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        showEmptyView(with: .noImagesAtAll)
        reloadTableView()
        return true
    }
}

extension ImageListController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    //MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countOfRows = fetchedImages.count
        
        if fetchedImages.isEmpty || isLastPage {
            return countOfRows
        } else {
            return countOfRows + 1
        }
    }
    
    //MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == fetchedImages.count {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingTableViewCell.self), for: indexPath) as! LoadingTableViewCell
            
            return loadingCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
            let image = fetchedImages
            cell.configureWith(model: image[indexPath.row].webformatURL)
            
            return cell
        }
    }
    
    //MARK: - Func willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let _ = cell as? LoadingTableViewCell, !isLoading {
            currentPage += 1
            loadMoreImages()
        }
    }
    
    //MARK: - heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == fetchedImages.count {
            return Constants.heightCell
        } else {
            return UIScreen.main.bounds.width
        }
    }
}

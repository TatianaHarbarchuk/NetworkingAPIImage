//
//  ViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit


final class ImageListController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
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
        
        setupTableView()
        setupEmptyStateView()
        setupSearchController()
    }
    
    //MARK: - setupSearchController
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.searchTextField.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: - setupTableView
    private func setupTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(with: MainImageCell.self)
        tableView?.register(with: LoadingTableViewCell.self)
        view.addSubview(emptyStateView)
        createActivityIndicator()
    }
    
    //MARK: - setupEmptyStateView
    private func setupEmptyStateView() {
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
        indicator = UIActivityIndicatorView(frame: CGRect(x: .zero, y: .zero, width: Constants.indicatorSize, height: Constants.indicatorSize))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView?.center ?? view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
    }
    
    //MARK: - Load Images
    private func loadImages(matching searchText: String) {
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
                    self.emptyStateView.isHidden = true
                    self.tableView?.isHidden = false
                    self.tableView?.reloadData()
                }
                self.indicator.stopAnimating()
            }
        }
    }
    
    //MARK: - Func loadMoreImages
    private func loadMoreImages() {
        isLoading = true
        imageService.fetchingAPIImages(matching: searchController.searchBar.text ?? "", page: currentPage) { result,error  in
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
    
    //MARK: - Func reloadTableView
    private func reloadTableView() {
        fetchedImages = []
        tableView?.reloadData()
    }
    
    //MARK: - Func showEmptyView
    private func showEmptyView(with images: EmptyStateType) {
        reloadTableView()
        emptyStateView.set(with: images)
        emptyStateView.isHidden = false
    }
    
    //MARK: - Func searchBarSearchButtonClicked
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchController.searchBar.text else { return }
        if searchBarText.isEmpty {
            showEmptyView(with: .noImagesAtAll)
        } else  {
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
            if let loadingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingTableViewCell.self), for: indexPath) as? LoadingTableViewCell {
                
                return loadingCell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MainImageCell.self), for: indexPath) as? MainImageCell {
                cell.delegate = self
                let image = fetchedImages[indexPath.row]
                cell.configureWith(model: image)
                
                return cell
            }
        }
        return UITableViewCell()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != fetchedImages.count {
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "showImageVC", sender: indexPath)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageVC" {
            if let destinationVC = segue.destination as? ImageViewController, let indexPath = sender as? IndexPath {
                let selectedRow = indexPath.row
                let model = fetchedImages[selectedRow]
                destinationVC.fetchedImage = model
                destinationVC.delegate = self
            }
        }
    }
}

extension ImageListController: MainImageCellDelegate, ImageViewControllerDelegate {
    func updateImage(imageURL: String, _ isFavourite: Bool) {
        var model = fetchedImages.first(where: { $0.webformatURL == imageURL })
        model?.isFavourite = isFavourite
        guard
            let index = fetchedImages.firstIndex(where: { $0.webformatURL == imageURL } ),
            let model = model
        else { return }
        fetchedImages[index] = model
        let indexPath = IndexPath(row: index, section: 0)
        tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func didTapLikeButton(url: String, isFavourite: Bool) {
        updateImage(imageURL: url, isFavourite)
    }
    func isFavouriteDidChange(for imageURL: String, _ isFavourite: Bool) {
        updateImage(imageURL: imageURL, isFavourite)
    }
}


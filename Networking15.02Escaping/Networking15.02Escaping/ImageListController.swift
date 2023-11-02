//
//  ViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit
import CoreData

final class ImageListController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    //MARK: - Constants
    private struct Constants {
        static let indicatorSize: CGFloat = 40
        static let heightCell: CGFloat = 60
        static let size: Int = 200
    }
    
    //MARK: - @IBOutlet
    @IBOutlet var collectionView: UICollectionView?
    
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
        
        setupCollectionView()
        setupEmptyStateView()
        setupSearchController()
    }
    
    //MARK: - Func ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Func setupCollectionView
    private func setupCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(with: CollectionViewCell.self)
        collectionView?.register(with: LoaderCollectionViewCell.self)
        if let layout = collectionView?.collectionViewLayout as? CustomCollectionViewLayout {
            layout.delegate = self
        }
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 10, right: 16)
    }
    
    //MARK: - Func setupSearchController
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.searchTextField.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: - Func setupEmptyStateView
    private func setupEmptyStateView() {
        createActivityIndicator()
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.set(with: EmptyStateType.noImagesAtAll)
        NSLayoutConstraint.activate([
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    //MARK: - Func createActivityIndicator
    private func createActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: .zero, y: .zero, width: Constants.indicatorSize, height: Constants.indicatorSize))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.collectionView?.center ?? view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
    }
    
    //MARK: - Func loadImages
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
                    self.collectionView?.isHidden = false
                    self.collectionView?.reloadData()
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
                self.collectionView?.reloadData()
                self.isLoading = false
            }
        }
    }
    
    //MARK: - Func reloadCollectionView
    private func reloadCollectionView() {
        fetchedImages = []
        collectionView?.reloadData()
    }
    
    //MARK: - Func showEmptyView
    private func showEmptyView(with images: EmptyStateType) {
        reloadCollectionView()
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
        reloadCollectionView()
        return true
    }
}

extension ImageListController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let countOfItems = fetchedImages.count
        if fetchedImages.isEmpty || isLastPage {
            return countOfItems
        } else {
            return countOfItems + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == fetchedImages.count {
            if let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LoaderCollectionViewCell.self), for: indexPath) as? LoaderCollectionViewCell {
                
                return loadingCell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as? CollectionViewCell {
                let image = fetchedImages[indexPath.item]
                //                cell.delegate = self
                cell.configureWith(model: image)
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let _ = cell as? LoaderCollectionViewCell, !isLoading {
            currentPage += 1
            loadMoreImages()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != fetchedImages.count {
            collectionView.deselectItem(at: indexPath, animated: true)
            performSegue(withIdentifier: "showImageVC", sender: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageVC" {
            if let destinationVC = segue.destination as? ImageViewController, let indexPath = sender as? IndexPath {
                let selectedRow = indexPath.item
                let model = fetchedImages[selectedRow]
                destinationVC.image = model
            }
        }
    }
}

extension ImageListController : CustomCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForImageAtIndexPath indexPath: IndexPath) -> CGFloat? {
        if !fetchedImages.indices.contains(indexPath.item) {
            return nil
        }
        
        let height = CGFloat(fetchedImages[indexPath.item].imageHeight)
        let width = CGFloat(fetchedImages[indexPath.item].imageWidth)
        return height / width
    }
}

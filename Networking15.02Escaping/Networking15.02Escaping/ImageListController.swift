//
//  ViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit

class ImageListController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    struct Constants {
        static let text = ""
        static let noImages = "No images found"
        static let enterImages = "Please enter text"
    }
    
    //MARK: - @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private var indicator = UIActivityIndicatorView()
    
    //MARK: - Properties
    private var fetchedImages: Image?
    private let emptyStateView = EmptyStateView(frame: .zero)
    private var searchTextField = UITextField()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupActivityIndicator()
        self.setupTableView()
        self.setupSearchBar()
        self.setupEmptyStateView()
    }
    //MARK: - setupTableView
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(with: TableViewCell.self)
        self.tableView.addSubview(emptyStateView)
    }
    //MARK: - setupSearchBar
    private func setupSearchBar() {
        self.searchBar.delegate = self
        self.searchBar.searchTextField.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.returnKeyType = .search
    }
    //MARK: - setupEmptyStateView
    private func setupEmptyStateView() {
        self.emptyStateView.setMessage(Constants.enterImages)
        self.emptyStateView.frame = self.tableView.frame
    }
    //MARK: - setupActivityIndicator
    private func setupActivityIndicator() {
        self.createActivityIndicator()
    }
    //MARK: - Setup Activity Indicator
    private func createActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
    }
    //MARK: - Load Images
    private func loadImages(matching searchText: String) {
        ImageService().fetchingAPIImages(matching: searchText) { result in
            self.fetchedImages = result
            DispatchQueue.main.async {
                if self.fetchedImages?.hits.isEmpty ?? true {
                    self.showEmptyViewNoImages(matching: Constants.noImages)
                } else {
                    self.emptyStateView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
                self.stopActivityIndicator()
            }
        }
    }
    //MARK: - Activity Indicator
    private func startActivityIndicator() {
        indicator.startAnimating()
    }
    private func stopActivityIndicator() {
        indicator.stopAnimating()
    }
    //MARK: - Func showEmptyViewNoImages
    private func showEmptyViewNoImages(matching text: String) {
        self.tableView.reloadData()
        self.fetchedImages = nil
        self.emptyStateView.isHidden = false
        self.emptyStateView.setMessage(text)
    }
    //MARK: - Func showEmptyView
    private func showEmptyViewWithImages(matching text: String) {
        self.fetchedImages = nil
        self.tableView.reloadData()
        self.emptyStateView.isHidden = false
        self.emptyStateView.setMessage(text)
    }
    //MARK: - Func searchBarSearchButtonClicked
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.isEmpty {
            showEmptyViewWithImages(matching: Constants.enterImages)
        } else  {
            tableView.isHidden = false
            emptyStateView.isHidden = true
            self.startActivityIndicator()
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
        showEmptyViewWithImages(matching: Constants.enterImages)
        return true
    }
}

extension ImageListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedImages?.hits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as? TableViewCell {
            guard let image = fetchedImages?.hits else { return cell }
            cell.configureWith(model: image[indexPath.row].webformatURL)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
}


extension UITableView {
    func register<T: UITableViewCell>(with cellType: T.Type) {
        register(UINib(nibName: String(describing: cellType), bundle: nil), forCellReuseIdentifier: String(describing: cellType))
    }
}





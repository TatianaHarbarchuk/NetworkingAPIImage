//
//  ViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit

class ImageListController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    struct Constants {
        static let noImages = "No images found"
        static let enterImages = "Please enter text..."
        static let indicatorSize: CGFloat = 40
    }
    
    //MARK: - @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    private var fetchedImages: Image?
    private let emptyStateView = EmptyStateView(frame: .zero)
    private var searchTextField = UITextField()
    private var indicator = UIActivityIndicatorView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupSearchBar()
        self.setupEmptyStateView()
        self.setupGestureRecognizer()
    }
    
    //MARK: - Setup Gesture Recognizer
    private func setupGestureRecognizer() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: - setupTableView
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(with: TableViewCell.self)
        self.view.addSubview(emptyStateView)
        self.createActivityIndicator()
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
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        self.emptyStateView.setMessage(Constants.enterImages)
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
        self.view.addSubview(indicator)
    }
    
    //MARK: - Load Images
    private func loadImages(matching searchText: String) {
        self.indicator.startAnimating()
        ImageService().fetchingAPIImages(matching: searchText) { [weak self] result in
            self?.fetchedImages = result
            DispatchQueue.main.async {
                if self?.fetchedImages?.hits.isEmpty ?? true {
                    self?.showEmptyView(withImages: false, matching: Constants.noImages)
                } else {
                    self?.emptyStateView.isHidden = true
                    self?.tableView.isHidden = false
                    self?.tableView.reloadData()
                }
                self?.indicator.stopAnimating()
            }
        }
    }
    
    //MARK: - Func showEmptyViewWithoutImagesText
    private func showEmptyView(withImages: Bool, matching text: String) {
        if withImages {
            self.fetchedImages = nil
            self.tableView.reloadData()
        } else {
            self.tableView.reloadData()
            self.fetchedImages = nil
        }
        self.emptyStateView.isHidden = false
        self.emptyStateView.setMessage(text)
    }
    
    //MARK: - Func searchBarSearchButtonClicked
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.isEmpty {
            showEmptyView(withImages: true, matching: Constants.enterImages)
        } else  {
            tableView.isHidden = false
            emptyStateView.isHidden = true
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
        showEmptyView(withImages: true, matching: Constants.enterImages)
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

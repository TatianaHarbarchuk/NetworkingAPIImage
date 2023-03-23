//
//  ViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit

class ImageListController: UIViewController, UISearchBarDelegate {
    
    struct Constants {
        static let text = ""
    }
    
    //MARK: - @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private var indicator = UIActivityIndicatorView()
    
    //MARK: - Properties
    private var fetchedImages: Image?
    private let emptyStateView = EmptyStateView(frame: .zero)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    //MARK: - Setup func
    private func setup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.returnKeyType = .search
        self.tableView.register(with: TableViewCell.self)
        self.tableView.addSubview(emptyStateView)
        self.emptyStateView.setMessage("Please enter text")
        self.emptyStateView.frame = self.tableView.frame
        self.setupActivityIndicator()
    }
    //MARK: - Setup Activity Indicator
    func setupActivityIndicator() {
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
                    self.tableView.reloadData()
                    self.fetchedImages = nil
                    self.emptyStateView.isHidden = false
                    self.emptyStateView.setMessage("No images found")
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
    //MARK: - Realize searchBarSearchButtonClicked
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if searchBarText.isEmpty {
            self.fetchedImages = nil
            self.tableView.reloadData()
            self.tableView.isHidden = false
            emptyStateView.isHidden = false
            emptyStateView.setMessage("Please enter text")
        } else  {
            tableView.isHidden = false
            emptyStateView.isHidden = true
            self.startActivityIndicator()
            loadImages(matching: searchBarText)
        }
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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




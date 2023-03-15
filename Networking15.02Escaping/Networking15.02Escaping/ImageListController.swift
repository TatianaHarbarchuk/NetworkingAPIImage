//
//  ViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit

class ImageListController: UIViewController, UISearchBarDelegate {
    
    struct Constants {
        static let identifier = "TableViewCell"
    }
    
    private var images: Image?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    fileprivate func setup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.returnKeyType = .search
        self.loadImage()
        self.tableView.register(UINib(nibName: Constants.identifier, bundle: nil), forCellReuseIdentifier: "cell")
    }
    //MARK: - Load Image API
    private func loadImageAPI(text: String) {
        ImageService().fetchingAPIImages(matching: text) { result in
            self.images = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //MARK: - Load Image Service
    private func loadImage() {
        loadImageAPI(text: "yellow")
    }
    //MARK: - Realize searchBarSearchButtonClicked
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadImageAPI(text: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ImageListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images?.hits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell {
            guard let image = images?.hits else { return cell }
            cell.configureWith(model: image[indexPath.row].webformatURL)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

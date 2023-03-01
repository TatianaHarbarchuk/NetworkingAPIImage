//
//  ViewController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 15.02.2023.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        searchBar.returnKeyType = .search
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

    }
    
    //MARK: - Load Image Service
    
    func loadImage() {
        ImageService().fetchingAPIImages(matching: "yellow", completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("Success")
            }
        })
    }
    
    //MARK: - Realize searchBarSearchButtonClicked
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        ImageService().fetchingAPIImages(matching: searchBar.text!) {
            self.tableView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
}














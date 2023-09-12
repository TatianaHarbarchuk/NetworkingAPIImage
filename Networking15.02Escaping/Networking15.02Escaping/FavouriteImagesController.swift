//
//  FavouriteImagesController.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 05.07.2023.
//

import UIKit
import CoreData

class FavouriteImagesController: UIViewController, UITableViewDelegate {
    //MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView?
    
    //MARK: - Properties
    private var fetchImages: [FavoriteCellImageModel] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        FavoriteImageService.shared.load()
        FavoriteImageService.shared.delegate = self
        fetchImages = FavoriteImageService.shared.getImages()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            FavoriteImageService.shared.delegate = self
        }
    
    //MARK: - Func setupTableView
    private func setupTableView() {
        tableView?.register(with: FavouriteImageCell.self)
        tableView?.dataSource = self
        tableView?.delegate = self
    }
}

extension FavouriteImagesController: UITableViewDataSource {
    
    //MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavouriteImageCell.self), for: indexPath) as? FavouriteImageCell {
            let image = fetchImages[indexPath.row]
            cell.configureWith(model: image)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

extension FavouriteImagesController: FavoriteImageHelperProtocol {
    func imageDidAddToFavorite(_ image: Photo, at indexPath: IndexPath) {
        let indexPath1 = IndexPath(row: indexPath.row, section: 0)
        fetchImages.append(FavoriteCellImageModel(photo: image))
        tableView?.reloadData()
    }
    
    func imageDidDeleteFromFavorite(at indexPath: IndexPath) {
        fetchImages.remove(at: indexPath.row)
        tableView?.deleteRows(at: [indexPath], with: .automatic)
    }
}

//
//  FavoriteImageHelper.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 02.08.2023.
//

import Foundation
import CoreData

protocol FavoriteImageHelperProtocol: AnyObject {
    func imageDidAddToFavorite( _ image: Photo, at indexPath: IndexPath)
    func imageDidDeleteFromFavorite(at indexPath: IndexPath)
}

class FavoriteImageService: NSObject {
    
    static var shared = FavoriteImageService()
    weak var delegate: FavoriteImageHelperProtocol?
    
    private lazy var fetchedResultsControler: NSFetchedResultsController<Photo> = {
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController<Photo>(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    func load() {
        do {
            try fetchedResultsControler.performFetch()
        } catch {
            print(error)
        }
        fetchedResultsControler.delegate = self
    }
    
    func saveFavoriteImages(model: Hit) {
        let context = CoreDataManager.shared.managedContext
        
        do {
            let request : NSFetchRequest<Photo> = Photo.fetchRequest()
            let predicate = NSPredicate(format: "id == %d AND url == %@", model.id, model.webformatURL)
            request.predicate = predicate
            let numberOfRecords = try context.fetch(request)
            print("Count \(numberOfRecords.count)")
            if numberOfRecords.isEmpty {
                let photo = Photo(context: context)
                photo.id = Int64(model.id)
                photo.url = model.webformatURL
                photo.date = Date()
                photo.isFavorite = model.isFavourite
                print("Save image \(photo.isFavorite), and id \(photo.id)")
            }
        } catch {
            print("Error saving context \(error)")
        }
        CoreDataManager.shared.saveContext()
    }
    
    func getImages() -> [FavoriteCellImageModel] {
        let fetchedObjects = fetchedResultsControler.fetchedObjects ?? []
        print("Get all fav images")
        return fetchedObjects.map{ FavoriteCellImageModel(id: Int($0.id), url: $0.url ?? "", isFavorite: $0.isFavorite)}
    }
    
    func isFavoriteImage(id: Int) -> Bool {
        guard let images = fetchedResultsControler.fetchedObjects else { return false }
        return images.map{Int($0.id)}.contains(id)
    }
    
    func deleteImage(with id: Int) {
        guard let images = fetchedResultsControler.fetchedObjects else { return }
        guard let deleteImage = images.first(where: { $0.id == id }) else { return }
        
        CoreDataManager.shared.managedContext.delete(deleteImage)
        print("Delete image from CoreData")
        CoreDataManager.shared.saveContext()
    }
}

extension FavoriteImageService: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        guard let image = anObject as? Photo else { return }
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { break }
            self.delegate?.imageDidAddToFavorite(image, at: indexPath)
        case .delete:
            guard let indexPath = indexPath else { break }
            self.delegate?.imageDidDeleteFromFavorite(at: indexPath)
        case .move, .update:
            return
        @unknown default:
            fatalError()
        }
    }
}

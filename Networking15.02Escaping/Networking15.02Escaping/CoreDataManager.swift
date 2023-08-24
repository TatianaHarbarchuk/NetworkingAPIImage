//
//  CoreDataManager.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 19.07.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    //MARK: - Static Property
    static let shared = CoreDataManager()
    
    //MARK: - Public Property
    lazy var managedContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FavoriteImage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - Public func
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Data is saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

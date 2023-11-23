//
//  Image+CoreDataProperties.swift
//  Networking15.02Escaping
//
//  Created by Tania Harbarchuk on 19.07.2023.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var id: Int64
    @NSManaged public var url: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var date: Date
}

extension Photo : Identifiable {

}

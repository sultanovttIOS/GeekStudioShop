//
//  ProductEntity+CoreDataProperties.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 3/9/24.
//
//

import Foundation
import CoreData


extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var title: String
    @NSManaged public var price: Float
    @NSManaged public var image: String
    @NSManaged public var desc: String
    @NSManaged public var category: String
    @NSManaged public var id: Int64
    @NSManaged public var rating: RatingEntity
}

extension ProductEntity : Identifiable {

}

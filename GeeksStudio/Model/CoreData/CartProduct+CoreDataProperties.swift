//
//  CartProduct+CoreDataProperties.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 3/9/24.
//
//

import Foundation
import CoreData


extension CartProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProduct> {
        return NSFetchRequest<CartProduct>(entityName: "CartProduct")
    }

    @NSManaged public var title: String
    @NSManaged public var desc: String
    @NSManaged public var category: String
    @NSManaged public var price: Float
    @NSManaged public var image: String
    @NSManaged public var id: Int64

}

extension CartProduct : Identifiable {

}

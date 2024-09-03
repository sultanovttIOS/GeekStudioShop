//
//  CategoryEntity+CoreDataProperties.swift
//  GeeksStudio
//
//  Created by Alisher Sultanov on 3/9/24.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var title: String?

}

extension CategoryEntity: Identifiable {

}

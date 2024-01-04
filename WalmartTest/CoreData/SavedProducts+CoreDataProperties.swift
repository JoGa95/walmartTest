//
//  SavedProducts+CoreDataProperties.swift
//  WalmartTest
//
//  Created by Jorge Garay on 03/01/24.
//
//

import Foundation
import CoreData


extension SavedProducts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedProducts> {
        return NSFetchRequest<SavedProducts>(entityName: "SavedProducts")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var price: String?

}

extension SavedProducts : Identifiable {

}

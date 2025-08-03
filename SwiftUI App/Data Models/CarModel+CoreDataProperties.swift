//
//  CarModel+CoreDataProperties.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//
//

import Foundation
import CoreData


extension CarModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarModel> {
        return NSFetchRequest<CarModel>(entityName: "CarModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageName: String?
    @NSManaged public var title: String?
    @NSManaged public var price: Double

}

extension CarModel: ManagedObject {

    /// Maps the CarModel managed object to a domain `Car` model.
    func toModel() -> Car {
        guard let id = self.id else {
            fatalError("Managed CarModel missing non-optional id")
        }
        
        return Car(
           id: id,
           imageName: self.imageName ?? "",
           title: self.title ?? "",
           price: self.price
        )
    }

    /// Populates the CarModel with data from a domain `Car` model.
    /// - Parameters:
    ///   - model: The domain model containing the data.
    ///   - context: The managed object context. (Used for potential relationships, but not strictly needed for this simple case)
    func populate(from model: Car, in context: NSManagedObjectContext) {
        // Assign properties from the domain model to the Core Data managed object
        self.id = model.id
        self.imageName = model.imageName
        self.title = model.title
        self.price = model.price
    }
}

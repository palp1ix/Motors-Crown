//
//  ManagedObject.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//

import CoreData

/// A protocol for Core Data managed objects to enable a clean mapping
/// between the persistence layer and the domain layer.
protocol ManagedObject: NSManagedObject {
    associatedtype Model: Storable
    
    /// Maps the Core Data managed object to a domain model.
    /// - Returns: A domain model instance.
    func toModel() -> Model
    
    /// Populates the managed object with data from a domain model.
    /// - Parameters:
    ///   - model: The domain model containing the data.
    ///   - context: The managed object context in which the object exists.
    func populate(from model: Model, in context: NSManagedObjectContext)
}

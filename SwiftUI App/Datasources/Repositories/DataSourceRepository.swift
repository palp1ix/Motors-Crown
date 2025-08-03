//
//  DataSourceRepository.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//

import Foundation

/// A generic data source repository protocol that defines standard CRUD operations.
/// It uses an associated type to work with any model conforming to the `Storable` protocol.
protocol DataSourceRepository {
    associatedtype Model: Storable
    
    /// Creates a new record in the data store.
    /// - Parameter model: The model instance to be created.
    func create(_ model: Model)
    
    /// Retrieves all records from the data store.
    /// - Returns: An array of model instances.
    func getAll() -> [Model]
    
    /// Updates an existing record in the data store.
    /// - Parameter model: The model instance with updated data.
    func update(_ model: Model)
    
    /// Deletes a record from the data store.
    /// - Parameter model: The model instance to be deleted.
    func delete(_ model: Model)
}

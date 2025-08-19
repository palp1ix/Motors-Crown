//
//  CoreDataSource.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//
import CoreData

/// A generic Core Data source that implements the DataSourceRepository protocol.
/// It can manage any `NSManagedObject` that conforms to the `ManagedObject` protocol.
class CoreDataSource<T: ManagedObject>: DataSourceRepository where T.Model: Storable {
    
    typealias Model = T.Model
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        guard context.persistentStoreCoordinator != nil else {
            fatalError("Context has no persistent store coordinator")
        }
    }
    
    func create(_ model: Model) {
        let managedObject = T(context: context)
        managedObject.populate(from: model, in: context)
        saveContext()
    }
    
    func getAll() -> [Model] {
        // T.fetchRequest() returns a generic NSFetchRequest<NSFetchRequestResult>.
        // We must cast it to NSFetchRequest<T> to get a typed result.
        // This cast is safe because T is an NSManagedObject subclass.
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else {
            print("Failed to create a typed fetch request for \(T.entity().name ?? "Unknown Entity").")
            return []
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { $0.toModel() }
        } catch {
            print("Failed to fetch entities: \(error)")
            return []
        }
    }
    
    func update(_ model: Model) {
        guard let existingObject = fetchFirst(for: model.id) else {
            print("Object with id \(model.id) not found for update.")
            return
        }
        existingObject.populate(from: model, in: context)
        saveContext()
    }
    
    func delete(_ model: Model) {
        guard let objectToDelete = fetchFirst(for: model.id) else {
            print("Object with id \(model.id) not found for deletion.")
            return
        }
        context.delete(objectToDelete)
        saveContext()
    }
    
    /// Helper method to fetch a single managed object by its unique ID.
    /// - Parameter id: The UUID of the object to fetch.
    /// - Returns: An optional managed object of type `T`.
    private func fetchFirst(for id: UUID) -> T? {
        guard let fetchRequest = T.fetchRequest() as? NSFetchRequest<T> else {
             print("Failed to create a typed fetch request for \(T.entity().name ?? "Unknown Entity").")
            return nil
        }
        
        // Use NSPredicate to find an object by its unique identifier.
        // Ensure your Core Data entity has an attribute named 'id' of type UUID.
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch entity with id \(id): \(error)")
            return nil
        }
    }
    
    /// Saves the managed object context if there are any changes.
    /// Rolls back the context in case of an error.
    private func saveContext() {
        guard context.hasChanges else { return }
        
        context.perform {
            do {
                try self.context.save()
            } catch {
                print("Failed to save context: \(error)")
                self.context.rollback()
            }
        }
    }
}

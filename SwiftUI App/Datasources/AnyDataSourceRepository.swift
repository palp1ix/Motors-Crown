//
//  AnyDataSourceRepository.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//


//
//  AnyDataSourceRepository.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//

import Foundation

/// A type-erased wrapper over any `DataSourceRepository`.
/// It allows using the repository without needing to specify its generic parameters.
struct AnyDataSourceRepository<Model: Storable> {
    
    // Internal closure that holds the implementation of the `create` method.
    private let _create: (Model) -> Void
    private let _getAll: () -> [Model]
    private let _update: (Model) -> Void
    private let _delete: (Model) -> Void
    
    /// Initializes the type-erased wrapper with a concrete repository.
    /// - Parameter repository: A concrete object conforming to `DataSourceRepository`.
    init<Repo: DataSourceRepository>(_ repository: Repo) where Repo.Model == Model {
        self._create = repository.create
        self._getAll = repository.getAll
        self._update = repository.update
        self._delete = repository.delete
    }

    /// Public methods that call the internal closures, forwarding the work
    /// to the underlying concrete repository.
    
    func create(_ model: Model) {
        _create(model)
    }
    
    func getAll() -> [Model] {
        return _getAll()
    }
    
    func update(_ model: Model) {
        _update(model)
    }
    
    func delete(_ model: Model) {
        _delete(model)
    }
}
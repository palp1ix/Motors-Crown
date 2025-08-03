//
//  Storable.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//

import Foundation

/// A protocol for any object that can be persisted.
protocol Storable {
    /// A unique identifier to find the object in the storage.
    var id: UUID { get }
}

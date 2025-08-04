//
//  MockDataSource.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//
import Foundation
import os

class MockDataSource: DataSourceRepository {
    
    typealias Model = Car
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.SwiftUIApp", category: String(describing: MockCarService.self))
    
    func create(_ model: Model) {
        logger.info("MockDataSource >>> Instance created")
    }

    func getAll() -> [Model] {
        logger.info( "MockDataSource >>> All instances retrieved")
        return [
            .init(id: UUID(), imageName: "bmw", title: "BMW", price: 100000),
            .init(id: UUID(), imageName: "audi", title: "Audi", price: 150000),
            .init(id: UUID(), imageName: "mercedes", title: "Mercedes", price: 200000),
        ]
    }
    
    func update(_ model: Model) {
        logger.info("MockDataSource >>> Instance updated")
    }
    
    func delete(_ model: Model) {
        logger.info( "MockDataSource >>> Instance deleted")
    }
}

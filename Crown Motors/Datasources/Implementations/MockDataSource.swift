//
//  MockDataSource.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//
import Foundation
import os
import SwiftUI

class MockDataSource: DataSourceRepository {
    
    typealias Model = Order
    
    let cars: [Car] = [
        .init(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440003")!, imageName: "audi-side", title: "Audi RS7 Sportback 2021", price: 71320),
        .init(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440004")!, imageName: "porshe-side", title: "Porsche Panamera Turbo 2020", price: 92110),
    ]
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.SwiftUIApp", category: String(describing: MockCarService.self))
    
    func create(_ model: Model) {
        logger.info("MockDataSource >>> Instance created")
    }

    func getAll() -> [Model] {
        logger.info( "MockDataSource >>> All instances retrieved")
        return [
            .init(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440010")!, car: cars[0], vinNumber: "WAU3MAFD1FN002656", color: Color(hex: "125188"), colorName: "Ocean Blue", engineVolume: 5.6, currentStatus: .inDelivery, currentPosition: "France Place Kléber, 67000", contactNumber: "+33 699177174"),
            
            .init(id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440011")!, car: cars[1], vinNumber: "WP1AB29P14L274895", color: Color(hex: "792131"), colorName: "Crimson", engineVolume: 6.1, currentStatus: .preparing, currentPosition: "France Place Kléber, 67000", contactNumber: "+33 699177174"),
        ]
    }
    
    func update(_ model: Model) {
        logger.info("MockDataSource >>> Instance updated")
    }
    
    func delete(_ model: Model) {
        logger.info( "MockDataSource >>> Instance deleted")
    }
}

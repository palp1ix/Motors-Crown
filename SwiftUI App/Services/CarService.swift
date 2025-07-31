//
//  CarService.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import Foundation

protocol CarService {
    func fetchCars(filters: Filters) -> [Car]
}

class MockCarService: CarService {
    func fetchCars(filters: Filters) -> [Car] {
        let allCars: [Car] = [
            .init(id: "0", imageName: "mercedes", title: "Mercedes-Benz 2021 Grand Coupe", price: 54891),
            .init(id: "1", imageName: "bmw", title: "BMW M5 Competition 2022", price: 63450),
            .init(id: "2", imageName: "audi", title: "Audi RS7 Sportback 2021", price: 71320),
            .init(id: "3", imageName: "porshe", title: "Porsche Panamera Turbo 2020", price: 92110),
            .init(id: "4", imageName: "tesla", title: "Tesla Model S Plaid 2023", price: 89990),
            .init(id: "5", imageName: "lexus", title: "Lexus LC 500h Coupe 2022", price: 77800),
        ]
        
        // We need this variable
        // because with empty prompt filtered cars would be empty
        let isPromptEmpty = filters.promptText.isEmpty
        
        return allCars.filter({
            // If we have empty prompt we should exclude prompting from filtering
            isPromptEmpty ? $0.price.isLess(than: filters.maxPrice) && $0.price > filters.minPrice
            : $0.title.lowercased().contains(filters.promptText.lowercased()) && $0.price.isLess(than: filters.maxPrice) && $0.price > filters.minPrice
        })
    }
}

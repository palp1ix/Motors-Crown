//
//  CarsListViewModel.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import Foundation
import Combine

class CarsListViewModel: ObservableObject {
    @Published var cars: [Car] = []
    @Published var searchText: String = ""
    
    private let carService: CarService
    private var cancellables = Set<AnyCancellable>()

    init(carService: CarService) {
        self.carService = carService
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] updatedSearchText in
                self?.filterCars(prompt: updatedSearchText)
            }
            .store(in: &cancellables)
            
        
        filterCars(prompt: "")
    }

    func filterCars(prompt: String) {
        self.cars = carService.fetchCars(prompt: prompt)
    }
}

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
    @Published var filters: Filters = Filters()
    
    private let carService: CarService
    private let datasource: AnyDataSourceRepository<Car>
    private var cancellables = Set<AnyCancellable>()

    init(carService: CarService, datasource: AnyDataSourceRepository<Car>) {
        self.carService = carService
        self.datasource = datasource
        
        $filters
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] updatedFilters in
                self?.filterCars(filters: updatedFilters)
            }
            .store(in: &cancellables)
        
        filterCars(filters: filters)
    }

    func filterCars(filters: Filters) {
        self.cars = carService.fetchCars(filters: filters)
    }
    
    func makeOrder(for car: Car) {
        datasource.create(car)
    }
}

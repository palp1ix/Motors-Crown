//
//  CarsListViewModel.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import Foundation
import Combine
import SwiftUI

class CarsListViewModel: ObservableObject {
    @Published var cars: [Car] = []
    @Published var storyGroups: [StoryGroup] = []
    @Published var filters: Filters = Filters()
    
    private let carService: CarService
    private let storiesService: StoriesService
    private let datasource: AnyDataSourceRepository<Order>
    private var cancellables = Set<AnyCancellable>()

    init(carService: CarService, storiesService: StoriesService, datasource: AnyDataSourceRepository<Order>) {
        self.carService = carService
        self.datasource = datasource
        self.storiesService = storiesService
        
        $filters
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] updatedFilters in
                self?.filterCars(filters: updatedFilters)
            }
            .store(in: &cancellables)
        
        filterCars(filters: filters)
        fetchStoryGroups()
    }

    func filterCars(filters: Filters) {
        self.cars = carService.fetchCars(filters: filters)
    }
    
    func fetchStoryGroups() {
        self.storyGroups = storiesService.fetchStoryGroups()
    }
    
    func makeOrder(for car: Car) {
        let order: Order = .init(id: UUID(), car: car, vinNumber: "WP1AB29P14L274895", color: Color.black, colorName: "Just Black", engineVolume: 4.4, currentStatus: .preparing, currentPosition: "Germany, Keiln St. Gegerodtsgasse 10", contactNumber: "+74 665 17 288")
        datasource.create(order)
    }
}

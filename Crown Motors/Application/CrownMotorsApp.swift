//
//  SwiftUI_AppApp.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/25/25.
//

import SwiftUI
import CoreData

@main
struct CrownMotorsApp: App {
    let datasource:  MockDataSource
    let carService: CarService
    let storiesService: StoriesService
    
    
    // MARK: - Initialization
    init() {
        self.carService = MockCarService()
        self.storiesService = MockStoriesService()
        self.datasource = MockDataSource()
    }

    var body: some Scene {
        WindowGroup {
            TabViewScreen(
                carsListViewModel: CarsListViewModel(
                    carService: carService,
                    storiesService: storiesService,
                    // AnyDataSourceRepository it's wrapping for all repositories
                    // It needed to avoid generic view model type (Type Erasure)
                    // And `tight coupling` effect
                    datasource: AnyDataSourceRepository(datasource)
                ),
                orderListViewModel: OrderListViewModel(
                    datasource: AnyDataSourceRepository(datasource)
                    )
            )
        }
    }
}



//
//  CrownMotorsApp.swift
//  Crown Motors App
//
//  Created by Artem Khachatryan on 7/25/25.
//

import SwiftUI
import YandexMapsMobile

@main
struct CrownMotorsApp: App {
    let datasource:  MockDataSource
    let carService: CarService
    let storiesService: StoriesService
    
    // MARK: - Initialization
    init() {
        // Initialize map api
        YMKMapKit.setApiKey("15db7f44-ddbf-4b83-b531-4aa5a379dbeb")
        YMKMapKit.sharedInstance()
        
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
                    datasource: AnyDataSourceRepository(datasource)
                ),
                orderListViewModel: OrderListViewModel(
                    datasource: AnyDataSourceRepository(datasource)
                    )
            )
        }
    }
}



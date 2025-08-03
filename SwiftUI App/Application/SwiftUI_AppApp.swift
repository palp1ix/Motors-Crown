//
//  SwiftUI_AppApp.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/25/25.
//

import SwiftUI
import CoreData

@main
struct SwiftUI_AppApp: App {
    let persistenceContainer = NSPersistentContainer(name: "CrownMotors")
    let datasource:  CoreDataSource<CarModel>
    let carService: CarService
    
    init() {
        self.carService = MockCarService()
        self.datasource = CoreDataSource(context: persistenceContainer.viewContext)
    }
    
    var body: some Scene {
        WindowGroup {
            TabViewScreen(
                carsListViewModel: CarsListViewModel(
                    carService: carService,
                    // AnyDataSourceRepository it's wrapping for all repositories
                    // It needed to avoid generic view model type (Type Erasure)
                    // And `tight coupling` effect
                    datasource: AnyDataSourceRepository(datasource)
                )
            )
        }
    }
}

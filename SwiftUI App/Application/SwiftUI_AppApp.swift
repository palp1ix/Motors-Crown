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
    let persistenceContainer: NSPersistentContainer
    let datasource:  CoreDataSource<CarModel>
    let carService: CarService
    
    init() {
        persistenceContainer = NSPersistentContainer(name: "CrownMotors")
        persistenceContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // В реальном приложении здесь должна быть более сложная обработка ошибок
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
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
                ),
                orderListViewModel: OrderListViewModel(
                    datasource: AnyDataSourceRepository(datasource)
                    )
            )
        }
    }
}

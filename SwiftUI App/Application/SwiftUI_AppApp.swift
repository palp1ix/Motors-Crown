//
//  SwiftUI_AppApp.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/25/25.
//

import SwiftUI

@main
struct SwiftUI_AppApp: App {
    var body: some Scene {
        WindowGroup {
            CarsList(viewModel: CarsListViewModel(carService: MockCarService()))
        }
    }
}

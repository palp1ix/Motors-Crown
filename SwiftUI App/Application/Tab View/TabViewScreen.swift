//
//  TabViewScreen.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/1/25.
//

import SwiftUI

struct TabViewScreen: View {
    @State var selection: Int = 0
    var carsListViewModel: CarsListViewModel
    
    var body: some View {
        TabView(selection: $selection) {
            CarsList(viewModel: carsListViewModel)
                .tabItem {
                    Image(systemName: "car")
                    Text("Cars")
                }
                .tag(0)
            
             Text("Вторая вкладка")
                 .tabItem {
                     Image(systemName: "note.text")
                     Text("Orders")
                 }
                 .tag(1)
                 .badge(10)
        }
        .tint(Theme.primaryAccent)
    }
}


#Preview {
    let carsListViewModel = CarsListViewModel(carService: MockCarService())
    TabViewScreen(carsListViewModel: carsListViewModel)
}

//
//  ContentView.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/25/25.
//

import SwiftUI

struct CarsList: View {
    @StateObject private var viewModel: CarsListViewModel
    
    init(viewModel: CarsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    // Header of the screen. Responsible for searching, filtering
                    // And text-description of company (Motors & Crown)
                    Header(searchableText: $viewModel.filters.promptText)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(viewModel.cars) { car in
                            CarCard(car: car)
                        }
                    }
                    .padding(.horizontal, 10)
                    .navigationDestination(for: Car.self, destination: { info in
                        CarDetailsView(car: info)
                    })
                }
                .scrollClipDisabled(false)
                .clipShape(Rectangle())
            }
        }
        .preferredColorScheme(.light)
        .environmentObject(viewModel) 
    }
}

#Preview {
    CarsList(viewModel: CarsListViewModel(carService: MockCarService()))
}

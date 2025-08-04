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

                    // Stories section with authors (car dealears and company)
                    StoriesScrollPreview(authors: viewModel.storyAuthors)
                        .padding(.top, 5)
                    
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(viewModel.cars) { car in
                            CarCard(car: car)
                        }
                    }
                    .padding(.horizontal, 10)
                    .navigationDestination(for: Car.self, destination: { info in
                        CarDetailsView(car: info)
                            .toolbar(.hidden, for: .tabBar)
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
    let datasource = MockDataSource()
    let carService = MockCarService()
    let viewModel = CarsListViewModel(carService: carService, storiesService: MockStoriesService(), datasource: AnyDataSourceRepository(datasource))
    
    CarsList(viewModel: viewModel)
}

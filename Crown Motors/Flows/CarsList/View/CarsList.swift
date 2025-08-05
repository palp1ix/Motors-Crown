//
//  ContentView.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/25/25.
//

import SwiftUI

struct CarsList: View {
    @StateObject private var viewModel: CarsListViewModel
    @State private var selectedStoryGroup: StoryGroup?
    
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
                    StoriesScrollPreview(storyGroups: viewModel.storyGroups) { selectedGroup in
                        selectedStoryGroup = selectedGroup
                    }
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
            .fullScreenCover(item: $selectedStoryGroup) { group in
                // This closure is called when selectedStoryGroupID is NOT nil.
                // It provides the non-optional ID.
                if let group = viewModel.storyGroups.first(where: { $0 == group }),
                   let index = viewModel.storyGroups.firstIndex(where: { $0 == group }) {
                    StoriesView(storyGroups: viewModel.storyGroups, startGroupIndex: index, currentGroupStory: $selectedStoryGroup)
                }
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

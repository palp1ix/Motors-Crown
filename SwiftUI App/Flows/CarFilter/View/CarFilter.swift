//
//  CarFilterView.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/31/25.
//

import SwiftUI

// View (screen) for settings all filters
struct CarFilter: View {
    @EnvironmentObject var viewModel: CarsListViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Theme.surface.ignoresSafeArea()
            VStack(alignment: .leading) {
                // Search bar for prompting
                CustomSearchBar(text: $viewModel.filters.promptText, backgroundColor: Theme.background)
                    .padding(.bottom, 20)
                
                Text("Compains")
                    .font(CFont.bold(20))
                
                // ScrollView of Campains buttons-logos
                CompaniesScrollPicker()
                    .padding(.bottom, 20)
                
                Text("Price range")
                    .font(CFont.bold(20))
                
                PriceRangeSelector()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .background(Color.clear)
        }
    }
}

struct PriceRangeSelector: View {
    @EnvironmentObject var viewModel: CarsListViewModel

    var body: some View {
        HStack {
            DecoratedNumberTextField(placeholder: "From", value: $viewModel.filters.minPrice)

            DecoratedNumberTextField(placeholder: "To", value: $viewModel.filters.maxPrice)
        }
    }
}





#Preview {
    CarFilter()
        .environmentObject(CarsListViewModel(carService: MockCarService()))
}

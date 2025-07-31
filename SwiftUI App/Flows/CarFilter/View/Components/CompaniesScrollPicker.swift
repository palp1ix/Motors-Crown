//
//  CompaniesScrollPicker.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/31/25.
//
import SwiftUI

struct CompaniesScrollPicker: View {
    @EnvironmentObject var viewModel: CarsListViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                Color.clear.frame(width: 0, height: 1)
                ForEach(CompanyLogos.allCases) { logo in
                    CompanyBox(isSelected: viewModel.filters.selectedCompanies.contains(logo), companyLogo: logo) { isSelected in
                        if isSelected {
                            viewModel.filters.selectedCompanies.append(logo)
                        } else {
                            viewModel.filters.selectedCompanies.removeAll { $0 == logo }
                        }
                    }
                }
            }
        }.padding(.horizontal, -10)
    }
}

// One structure element of `CompaniesScrollPicker`
struct CompanyBox: View {
    @State var isSelected: Bool
    var companyLogo: CompanyLogos
    var onSelect: ((Bool) -> Void)
    
    var body: some View {
        Image(companyLogo.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .padding(12)
            .background(isSelected ? Theme.primaryAccent : Theme.background)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .onTapGesture {ture in
                withAnimation() {
                    isSelected.toggle()
                    onSelect(isSelected)
                }
            }
    }
}

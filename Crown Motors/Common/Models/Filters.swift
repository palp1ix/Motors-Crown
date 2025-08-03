//
//  Filters.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/31/25.
//

import Foundation
import Combine

class Filters: ObservableObject {
    @Published var selectedCompanies: [CompanyLogos] = []
    @Published var minPrice: Double
    @Published var maxPrice: Double
    @Published var promptText: String
    
    init() {
        self.minPrice = 0
        self.maxPrice = .infinity
        self.promptText = ""
        self.selectedCompanies = []
    }
    
    init (selectedCompanies: [CompanyLogos], minPrice: Double, maxPrice: Double, promptText: String) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.promptText = promptText
        self.selectedCompanies = selectedCompanies
    }
}

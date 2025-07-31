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
    @Published var priceRange: ClosedRange<Double>?
    @Published var promptText: String
    
    init() {
        self.priceRange = nil
        self.promptText = ""
        self.selectedCompanies = [.audi_logo]
    }
    
    init(selectedCompanies: [CompanyLogos], priceRange: ClosedRange<Double>, promptText: String) {
        self.selectedCompanies = selectedCompanies
        self.priceRange = priceRange
        self.promptText = promptText
    }
}

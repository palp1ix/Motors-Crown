//
//  OrderListViewModel.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//
import Foundation
import Combine

class OrderListViewModel: ObservableObject {
    @Published var orderedCars: [Car] = []
    @Published var orderCount: Int = 0
    
    var datasource: AnyDataSourceRepository<Car>
    
    init(datasource: AnyDataSourceRepository<Car>) {
        self.datasource = datasource
        
        fetchOrders()
    }
    
    func fetchOrders() {
        self.orderedCars = datasource.getAll()
        self.orderCount = self.orderedCars.count
    }
}

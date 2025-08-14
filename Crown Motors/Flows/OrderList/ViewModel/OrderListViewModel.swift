//
//  OrderListViewModel.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//
import Foundation
import Combine

class OrderListViewModel: ObservableObject {
    @Published var orderedCars: [Order] = []
    @Published var orderCount: Int = 0
    
    var datasource: AnyDataSourceRepository<Order>
    
    init(datasource: AnyDataSourceRepository<Order>) {
        self.datasource = datasource
        
        fetchOrders()
    }
    
    func fetchOrders() {
        self.orderedCars = datasource.getAll()
        self.orderCount = self.orderedCars.count
    }
}

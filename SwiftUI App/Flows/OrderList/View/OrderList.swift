//
//  OrderList.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/1/25.
//

import SwiftUI

struct OrderList: View {
    @StateObject private var viewModel: OrderListViewModel
    
    init(viewModel: OrderListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack {
                Text("Your Orders: \(viewModel.orderCount)").font(CFont.bold(24))
                List(viewModel.orderedCars) { car in
                    CarCard(car: car)
                }
            }.padding(.horizontal)
                .onAppear {
                    viewModel
                        .fetchOrders()
                }
        }
    }
}

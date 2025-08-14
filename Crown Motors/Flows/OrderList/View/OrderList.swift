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
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Orders")
                        .foregroundStyle(Theme.primaryText)
                        .font(CFont.bold(24))
                    Text("Track your international car orders in real-time. Monitor delivery status, shipping progress, customs clearance, and documentation for vehicles being imported from abroad. Stay updated on estimated arrival dates, costs, and required paperwork for each of your ordered cars.")
                        .foregroundStyle(Theme.secondaryText)
                        .font(CFont.bold(16))
                        .padding(.bottom, 10)
                    
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.orderedCars) { order in
                            OrderCard(order: order)
                        }
                    }
                }
                .padding([.horizontal, .top])
            }
            .onAppear {
                viewModel
                    .fetchOrders()
            }
            
        }
    }
}


#Preview {
    let datasource = MockDataSource()
    return OrderList(
        viewModel: OrderListViewModel(
            datasource: AnyDataSourceRepository(datasource)
        )
    )
}


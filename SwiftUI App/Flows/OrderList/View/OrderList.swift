//
//  OrderList.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/1/25.
//

import SwiftUI

struct OrderList: View {
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack {
                Text("Order List")
            }
        }
    }
}

#Preview {
    OrderList()
}

//  ExtendedCarCard.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import SwiftUI

struct OrderCard: View {
    var order: Order
    @State var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(order.car.title)
                            .foregroundStyle(Theme.primaryText)
                            .font(CFont.bold(20))
                        Text(order.vinNumber)
                            .foregroundStyle(Theme.secondaryText)
                            .font(CFont.regular(15))
                    }

                    Spacer()
                    Text(order.currentStatus.rawValue)
                        .foregroundStyle(Theme.primaryAccent)
                        .font(CFont.bold(17))
                }
                
                Image(order.car.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 15)
                
                HStack(alignment: .center) {
                    Image(systemName: "engine.combustion")
                        .foregroundStyle(Theme.primaryText)
                    Text(String(order.engineVolume) + "L")
                        .foregroundStyle(Theme.primaryText)
                        .font(CFont.bold(16))
                    
                    Spacer()
                    
                    Circle()
                        .fill(order.color)
                        .frame(width: 18, height: 18)
                    Text(order.colorName)
                        .foregroundStyle(Theme.primaryText)
                        .font(CFont.bold(16))
                    
                    Spacer()
                    
                    Button("More", systemImage: isExpanded ? "chevron.up" : "chevron.down") {
                            isExpanded.toggle()
                    }
                    .foregroundStyle(Theme.primaryAccent)
                }
            }
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 20)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}


#Preview {
    let order = MockDataSource().getAll()[0]
    return OrderCard(order: order)
}

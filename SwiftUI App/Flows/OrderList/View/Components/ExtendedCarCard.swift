//
//  ExtendedCarCard.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/3/25.
//


//
//  ExtendedCarCard.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import SwiftUI

struct ExtendedCarCard: View {
    var car: Car

    var body: some View {
                VStack(alignment: .center, spacing: 0) {
                    // The image container's height is now proportional to the card's width,
                    // ensuring the car image has enough space to be fully displayed without being clipped.
                    Image(car.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        .clipped()

                    VStack(alignment: .leading, spacing: 8) {
                        Text(car.title)
                            .lineLimit(2)
                            .font(CFont.bold(24))
                            .foregroundColor(Theme.primaryAccent)

                        HStack {
                            Text(car.price, format: .currency(code: "USD").rounded())
                                    .font(CFont.bold(22))
                                    .foregroundColor(Theme.primaryText)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 20)
                }
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


#Preview {
    ExtendedCarCard(car: .init(id: UUID(), imageName: "mercedes", title: "Mercedes Grand Coupe", price: 67844.19))
        .border(Color.red, width: 3)
}

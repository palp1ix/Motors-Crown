//
//  UICarCard.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import SwiftUI

struct CarCard: View {
    var car: Car

    var body: some View {
        NavigationLink(value: car) {
            VStack(alignment: .center) {
                Color.clear

                    .frame(height: 65)
                    .overlay(
                        Image(car.imageName)
                            .resizable()
                            .scaledToFill()
                            .transition(.opacity)
                            .padding(.horizontal, 20)
                    )
                    .padding(.top, 10)
                    .clipped()
                


                VStack(alignment: .leading) {
                    Text(car.title)
                        .lineLimit(2)
                        .font(CFont.bold(15))
                        .foregroundColor(Theme.primaryText)
                    
                    ExtraInfoLine()

                    HStack {
                        Text(car.price, format: .currency(code: "USD").rounded())
                            .font(CFont.bold(16))
                            .foregroundColor(Theme.primaryText)
                        Spacer()
                        AnimatedArrowButton()
                    }
                }
                .padding(15)
            }
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

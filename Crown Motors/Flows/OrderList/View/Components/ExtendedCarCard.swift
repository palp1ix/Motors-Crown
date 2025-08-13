//  ExtendedCarCard.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import SwiftUI

struct ExtendedCarCard: View {
    var car: Car

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                Image(car.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .clipped()

                VStack(alignment: .center, spacing: 14) {
                    VStack(spacing: 6) {
                        Image(systemName: "car.rear.road.lane.dashed")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tint(Theme.primaryAccent)
                            .frame(width: 40, height: 25)
                        Theme.primaryAccent
                            .frame(height: 4)
                            .clipShape(.rect(cornerRadius: 2))
                    }
                    .padding(.bottom, 10)

                    VStack(alignment: .center, spacing: 8) {
                        Text(car.title)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .font(CFont.bold(20))
                            .foregroundColor(Theme.primaryAccent)

                        Text(car.price, format: .currency(code: "USD").rounded())
                            .font(CFont.bold(18))
                            .foregroundColor(Theme.primaryText)
                    }

                    Image(systemName: "info")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .padding(12)
                        .frame(width: 45, height: 45)
                        .background(Theme.primaryAccent)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.10), radius: 8, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .padding(6)
    }
}


#Preview {
    ExtendedCarCard(car: .init(id: UUID(), imageName: "mercedes", title: "Mercedes Grand Coupe", price: 67844.19))
        .border(Color.red, width: 3)
}

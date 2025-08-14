//
//  CarDetailsView.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/26/25.
//

import SwiftUI

struct CarDetailsView: View {
    // Information about car
    let car: Car
    @EnvironmentObject private var viewModel: CarsListViewModel

    
    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text(car.title)
                        .font(CFont.bold(26))
                        .foregroundColor(Theme.primaryText).padding(.top, 20)
                    
                    Image(car.imageName).resizable().aspectRatio(contentMode: .fit).padding(.top, 20)
                    
                    HStack {
                        PriceParam(title: "Price", value: car.price)
                        Spacer()
                        PriceParam(title: "Delivery", value: 5899)
                    }.padding(.horizontal, 10)
                    

                        
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .center) {
                            OverviewParam(imageName: "speedometr", title: "Top Speed", value: "331 km/h")
                            Spacer()
                            Divider().frame(height: 120)
                            Spacer()
                            OverviewParam(imageName: "speed", title: "Horse Power", value: "661 hp")
                            Spacer()
                            Divider().frame(height: 120)
                            Spacer()
                            OverviewParam(imageName: "odometr", title: "Distance", value: "791 km")
                        }
                        .padding(.horizontal)
                        
                        Text("A Mercedes-AMG engine starts with the state of the art. Everything from fuel pressure to exhaust routing is developed to quicken, heighten and intensify its response, and yours. From patented processes to cut friction to a new generation of electrified performance, AMG technology is fueled by its racing success.")
                            .lineLimit(nil)
                            .foregroundStyle(Theme.secondaryText)
                            .font(CFont.bold(14))
                    }
                    .padding(20)
                    .background(Theme.surface)
                    .clipShape(.rect(cornerRadius: 20))

                }
                .padding(.horizontal)
            }.padding(.bottom, 70)
            
            
            HStack {
                AnimatedPrimaryButton(text: "Book a Visit", isPrimary: false)
                AnimatedPrimaryButton(text: "Buy Now", isPrimary: true) {
                    FancyNotificationCenter.shared.create(notification: .success(title: "Successfully placed order!", body: "Your order is being processed. You will receive a confirmation email shortly."))
                    viewModel.makeOrder(for: car)
                }
            }.padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

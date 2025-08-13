//
//  TabViewScreen.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 8/1/25.
//

import SwiftUI
import UIKit

struct TabViewScreen: View {
    @State var selection: Int = 0
    var carsListViewModel: CarsListViewModel
    var orderListViewModel: OrderListViewModel
    
    init(carsListViewModel: CarsListViewModel, orderListViewModel: OrderListViewModel) {
        self.carsListViewModel = carsListViewModel
        self.orderListViewModel = orderListViewModel
        FancyNotificationCenter.shared.create(notification: .info(title: "Welcome to Crown Motors!", body: "Explore our wide range of cars and manage your orders easily. Enjoy your experience! 🚗💨"))
    }

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                CarsList(viewModel: carsListViewModel)
                    .tabItem {
                        Image(uiImage: UIImage(named: "car")?.tabImageItem(isSelected: selection == 0, size: CGSize(width: 35, height: 35)) ?? UIImage())
                    }
                    .tag(0)
                
                OrderList(viewModel: orderListViewModel)
                     .tabItem {
                         Image(uiImage: UIImage(named: "shopping_bag")?.tabImageItem(isSelected: selection == 1) ?? UIImage())
                     }
                     .tag(1)
            }
            .tint(Theme.primaryAccent)
            
            FancyNotificationWrapper()
                .allowsHitTesting(true)
                .ignoresSafeArea()
        }
    }
    
}

fileprivate extension UIImage {
    func tabImageItem(isSelected: Bool, size: CGSize = CGSize(width: 25, height: 25)) -> UIImage {
        
        return UIGraphicsImageRenderer(size: size).image { context in
            let rect = CGRect(origin: .zero, size: size)
            let clipPath = UIBezierPath(ovalIn: rect)
            clipPath.addClip()
            self.draw(in: rect)
        }
        .withRenderingMode(.alwaysTemplate)
    }
}

#Preview {
    TabViewScreen(
        carsListViewModel: CarsListViewModel(
            carService: MockCarService(),
            storiesService: MockStoriesService(),
            datasource: AnyDataSourceRepository(MockDataSource())
        ),
        orderListViewModel: OrderListViewModel(
            datasource: AnyDataSourceRepository(MockDataSource())
        )
    )
}

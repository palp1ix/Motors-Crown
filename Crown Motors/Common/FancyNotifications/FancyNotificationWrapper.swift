//
//  FancyNotificationWrapper.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/9/25.
//

import SwiftUI
import UIKit

struct FancyNotificationWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> FancyNotificationContainer {
        return FancyNotificationContainer()
    }
    
    func updateUIView(_ uiView: FancyNotificationContainer, context: Context) {
        // No need to update the view in this case
    }
}

//
//  PriceParam.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import SwiftUI

struct PriceParam: View {
    let title: String
    let value: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(CFont.regular(16))
                .foregroundStyle(Theme.secondaryText)
            
            // Используем отформатированную строку
            Text(value, format: .currency(code: "USD"))
                .font(CFont.bold(30))
                .foregroundColor(Theme.primaryText)
        }
    }
}

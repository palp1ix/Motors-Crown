//
//  DecoratedNumberTextField.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/31/25.
//
import SwiftUI

struct DecoratedNumberTextField: View {
    var placeholder: String
    @Binding var value: Double
    
    var body: some View {
        TextField(placeholder, value: $value, format: .number)
            .keyboardType(.decimalPad)
            .tint(Theme.primaryAccent)
            .frame(height: 45)
            .padding(.leading, 13)
            .background(Theme.background)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

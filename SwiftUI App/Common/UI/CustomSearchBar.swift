//
//  CustomSearchBar.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/26/25.
//
import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void = {}

    var body: some View {
        ZStack(alignment: .trailing) {
            TextField(
                "",
                      text: $text,
                prompt: Text("Поиск")                    
                    .foregroundColor(Theme.secondaryText)
                          .font(CFont.bold(17))
            )
            .frame(height: 30)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Theme.surface)
                .cornerRadius(20)
                .font(CFont.bold(16))
                .foregroundColor(Theme.primaryText)
                .disableAutocorrection(true)
            Button(action: {
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
                    .font(CFont.bold(17))
                    .foregroundColor(Theme.icon)
                    .frame(width: 50, height: 50)
                    .background(Theme.primaryAccent)
                    .clipShape(RoundedRectangle(cornerRadius: 19))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    @State var text = ""
    CustomSearchBar(text: $text)
}

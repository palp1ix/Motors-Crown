//
//  Header.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import SwiftUI

struct Header: View {
    @Binding var searchableText: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image("crown").resizable().renderingMode(.template).aspectRatio(contentMode: .fit)
                .foregroundStyle(Theme.primaryAccent).frame(width: 55, height: 55)
            VStack(alignment: .leading) {
                Text("Motors & Crown")
                    .italic()
                    .font(CFont.bold(20))
                    .foregroundColor(Theme.primaryText)
                Text("Where Power Meets Elegance")
                    .font(CFont.bold(14))
                    .italic()
                    .foregroundColor(Theme.primaryText)
            }
            Spacer()
            ZStack {
                Circle().fill(Theme.primaryAccent).frame(width: 40, height: 40)
                Image(systemName: "person.fill").foregroundStyle(Theme.icon)
            }.padding(.trailing, 10)
        }.padding(.horizontal)
        CustomSearchBar(text: $searchableText).padding(.top)
        Text("Motors & Crown — это не просто автомобили, это выбор тех, кто ценит престиж, мощь и безупречный стиль. Мы отбираем лучшие экземпляры люксовых марок, чтобы каждая покупка становилась заявлением. Без компромиссов. Только вершина.")
            .font(CFont.bold(15)) // << Замена
            .italic()
            .foregroundStyle(Theme.secondaryText)
            .padding()
    }
}

//
//  ExtraInfoLine.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import SwiftUI

struct ExtraInfoLine: View {
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .resizable()
                .foregroundStyle(Theme.star)
                .frame(width: 13, height: 13)
            Text("4.9 (1224)")
                .font(CFont.bold(13)) // << Замена
                .foregroundStyle(Theme.secondaryText)
        }.clipped()
    }
}

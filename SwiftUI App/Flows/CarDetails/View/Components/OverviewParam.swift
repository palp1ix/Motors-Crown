//
//  OverviewParam.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import SwiftUI

struct OverviewParam: View {
    let imageName: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack{
                Circle().fill(Theme.primaryAccent).frame(width: 50, height: 50)
                Image(imageName).resizable().renderingMode(.template).frame(width: 30, height: 30).foregroundStyle(Theme.surface)
            }
            Text(title)
                .font(CFont.bold(13))
                .foregroundColor(Theme.secondaryText)
            Text(value)
                .font(CFont.bold(16))
                .foregroundColor(Theme.primaryText)
        }
    }
}

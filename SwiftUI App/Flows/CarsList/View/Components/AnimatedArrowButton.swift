//
//  AnimatedArrowButton.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/27/25.
//

import SwiftUI

struct AnimatedArrowButton: View {
    @State private var moveOut = false
    @State private var moveIn = false
    @State private var isAnimating = false

    var body: some View {
        Button(action: {
            guard !isAnimating else { return }
            isAnimating = true
            moveIn = false
            withAnimation(.easeInOut(duration: 0.4)) {
                moveOut = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                moveOut = false
                moveIn = true
                withAnimation(.easeInOut(duration: 0.1)) {
                    moveIn = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    isAnimating = false
                }
            }
        }) {
            HStack {


                Image(systemName: "arrow.forward")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .offset(x: moveOut ? 30 : (moveIn ? -15 : 0))
                    .opacity((moveOut && !moveIn) ? 0 : 1)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 8)
            .foregroundStyle(Theme.icon)
            .background(Theme.primaryAccent)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

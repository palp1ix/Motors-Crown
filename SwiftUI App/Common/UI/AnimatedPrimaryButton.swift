//
//  AnimatedPrimaryButton.swift
//  SwiftUI App
//
//  Created by Artem Khachatryan on 7/26/25.
//
import SwiftUI

struct AnimatedPrimaryButton: View {
    let text: String
    let isPrimary: Bool
    @State private var moveOut = false
    @State private var moveIn = false
    @State private var isAnimating = false

    var body: some View {
        Button(
            action: {
            guard !isAnimating else { return }
            isAnimating = true
            moveIn = false
            withAnimation(.easeInOut(duration: 0.3)) {
                moveOut = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                moveOut = false
                moveIn = true
                withAnimation(.easeInOut(duration: 0.1)) {
                    moveIn = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = false
                }
            }
        }) {
            HStack {
                Text(text)
                    .font(CFont.bold(16)).foregroundStyle(!isPrimary ? Theme.primaryText : .white) // << Замена
                
                if isPrimary {
                    Image(systemName: "arrow.forward")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .offset(x: moveOut ? 30 : (moveIn ? -30 : 0))
                        .opacity((moveOut && !moveIn) ? 0 : 1)
                        .padding(.leading, 10)                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)            
            .foregroundStyle(Theme.icon)
            .background(isPrimary ? Theme.primaryAccent : Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

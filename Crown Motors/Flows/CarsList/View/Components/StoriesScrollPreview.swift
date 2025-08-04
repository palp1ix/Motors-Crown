//
//  StoriesScrollPreview.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/4/25.
//
import SwiftUI

struct StoriesScrollPreview: View {
    let authors: [StoryAuthor]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Color.clear
                    .frame(width: 5, height: 0) // Spacer to align the first author in the center
                ForEach(authors) { author in
                    VStack(alignment: .center) {
                        Image(author.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 65, height: 65)
                            .clipShape(Circle())
                            .padding(4)
                            .overlay(
                                Circle().stroke(Theme.primaryAccent, lineWidth: 3)
                            )
                            .padding(.bottom, 5)
                        
                        Text(author.name).font(CFont.bold(14))
                    }
                    .padding(5)
                }
            }
        }
    }
}

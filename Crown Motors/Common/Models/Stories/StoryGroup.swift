//
//  StoryGroup.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/5/25.
//


import Foundation

// Group of stories by a specific author
struct StoryGroup: Identifiable {
    let id = UUID()
    let author: StoryAuthor
    let stories: [Story]
}

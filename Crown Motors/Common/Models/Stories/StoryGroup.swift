//
//  StoryGroup.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/5/25.
//


import Foundation

// Group of stories by a specific author
struct StoryGroup: Identifiable, Equatable {
    let id = UUID()
    let author: StoryAuthor
    let stories: [Story]
    
    static func == (group1: StoryGroup, group2: StoryGroup) -> Bool {
        return group1.id == group2.id
    }
}

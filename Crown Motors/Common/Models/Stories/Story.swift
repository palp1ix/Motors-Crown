//
//  Story.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/4/25.
//

import Foundation

struct Story: Identifiable, Hashable, Storable {
    let id: UUID
    let author: StoryAuthor
    let content: String
    let timestamp: Date
}

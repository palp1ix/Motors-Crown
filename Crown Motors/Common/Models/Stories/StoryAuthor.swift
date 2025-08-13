//
//  StorieAuthor.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/4/25.
//
import Foundation

struct StoryAuthor: Identifiable, Hashable, Storable {
    let id: UUID
    let name: String
    let imageName: String
}


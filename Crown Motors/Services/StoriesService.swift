//
//  StoriesService.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/4/25.
//
import Foundation

protocol StoriesService {
    func fetchStoryAuthors() -> [StoryAuthor]
}

class MockStoriesService: StoriesService {
    let storyAuthors = [
        StoryAuthor(id: UUID(), name: "Jet car", imageName: ImageAsset.cardealer1.rawValue),
        StoryAuthor(id: UUID(), name: "Rockets", imageName: ImageAsset.cardealer2.rawValue),
        StoryAuthor(id: UUID(), name: "BMW Dealer", imageName: ImageAsset.cardealer3.rawValue),
    ]
    
    func fetchStoryAuthors() -> [StoryAuthor] {
        return storyAuthors
    }
}


//
//  StoriesService.swift
//  Crown Motors
//
//  Created by Artem Khachatryan on 8/4/25.
//
import Foundation

protocol StoriesService {
    func fetchStoryGroups() -> [StoryGroup]
}

class MockStoriesService: StoriesService {
    // Create testing data
    let author1 = StoryAuthor(id: UUID(), name: "Jet car", imageName: ImageAsset.cardealer1.rawValue)
    let author2 = StoryAuthor(id: UUID(), name: "Rockets", imageName: ImageAsset.cardealer2.rawValue)

    var stories1: [Story] { [
        Story(id: UUID(), author: author1, content: "https://assets.klap.app/web-assets/fred-compressed.mp4", timestamp: Date()),
        Story(id: UUID(), author: author1, content: "https://assets.klap.app/web-assets/casey-compressed.mp4", timestamp: Date())
    ] }
    
    var stories2: [Story] { [
        Story(id: UUID(), author: author2, content: "https://assets.klap.app/web-assets/sara-compressed.mp4", timestamp: Date()),
        Story(id: UUID(), author: author2, content: "https://assets.klap.app/web-assets/unbox-compressed.mp4", timestamp: Date())
    ] }
    
    var storyGroups: [StoryGroup] { [
        StoryGroup(author: author1, stories: stories1),
        StoryGroup(author: author2, stories: stories2)
    ] }
    
    func fetchStoryGroups() -> [StoryGroup] {
        return storyGroups
    }
}



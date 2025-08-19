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
    let author1 = StoryAuthor(id: UUID(), name: "Cars Video", imageName: ImageAsset.cardealer1.rawValue)
    let author2 = StoryAuthor(id: UUID(), name: "Rockets", imageName: ImageAsset.cardealer2.rawValue)

    var stories1: [Story] { [
        Story(id: UUID(), author: author1, content: "audi.mp4", timestamp: Date()),
        Story(id: UUID(), author: author1, content: "bmw.mp4", timestamp: Date())
    ] }
    
    var stories2: [Story] { [
        Story(id: UUID(), author: author2, content: "mercedes.mp4", timestamp: Date()),
    ] }
    
    var storyGroups: [StoryGroup] { [
        StoryGroup(author: author1, stories: stories1),
        StoryGroup(author: author2, stories: stories2)
    ] }
    
    func fetchStoryGroups() -> [StoryGroup] {
        return storyGroups
    }
}



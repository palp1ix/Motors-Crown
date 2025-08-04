import SwiftUI

struct StoriesView: View {
    
    // The ViewModel is the single source of truth and is created here.
    @StateObject private var viewModel: StoriesViewModel
    
    // The initializer now takes the starting index for which group to show first.
    init(storyGroups: [StoryGroup], startGroupIndex: Int = 0) {
        self._viewModel = StateObject(wrappedValue: StoriesViewModel(
            storyGroups: storyGroups,
            startGroupIndex: startGroupIndex
        ))
    }

    var body: some View {
        // A TabView with a paging style allows for horizontal swiping between authors.
        TabView(selection: $viewModel.currentGroupIndex) {
            ForEach(Array(viewModel.storyGroups.enumerated()), id: \.element.id) { index, _ in
                SingleStoryView(viewModel: viewModel)
                    .tag(index) // Tagging the view connects it to the TabView's selection.
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) // Hides the default page indicator dots.
        .background(Color.black)
        .ignoresSafeArea()
    }
}


// MARK: - Preview for Testing

#Preview {

    // Create testing data
    let author1 = StoryAuthor(id: UUID(), name: "Jet car", imageName: ImageAsset.cardealer1.rawValue)
    let author2 = StoryAuthor(id: UUID(), name: "Rockets", imageName: ImageAsset.cardealer2.rawValue)

    let stories1 = [
        Story(id: UUID(), author: author1, content: "https://assets.klap.app/web-assets/fred-compressed.mp4", timestamp: Date()),
        Story(id: UUID(), author: author1, content: "https://assets.klap.app/web-assets/casey-compressed.mp4", timestamp: Date())
    ]
    
    let stories2 = [
        Story(id: UUID(), author: author2, content: "https://assets.klap.app/web-assets/sara-compressed.mp4", timestamp: Date()),
        Story(id: UUID(), author: author2, content: "https://assets.klap.app/web-assets/unbox-compressed.mp4", timestamp: Date())
    ]
    
    let storyGroups = [
        StoryGroup(author: author1, stories: stories1),
        StoryGroup(author: author2, stories: stories2)
    ]
    
    return StoriesView(storyGroups: storyGroups)
}

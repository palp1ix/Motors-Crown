import SwiftUI

struct StoriesView: View {
    
    // The ViewModel is the single source of truth and is created here.
    @StateObject private var viewModel: StoriesViewModel
    @Binding var currentGroupStory: StoryGroup?
    // This offset is used to view the closing gesture.
    @State var closingOffset: CGFloat = 0
    
    // The initializer now takes the starting index for which group to show first.
    init(storyGroups: [StoryGroup], startGroupIndex: Int = 0, currentGroupStory: Binding<StoryGroup?>) {
        self._viewModel = StateObject(wrappedValue: StoriesViewModel(
            storyGroups: storyGroups,
            startGroupIndex: startGroupIndex
        ))
        
        _currentGroupStory = currentGroupStory
    }
    
    init(viewModel: StoriesViewModel, currentGroupStory: Binding<StoryGroup?>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._currentGroupStory = currentGroupStory
    }

    // In StoriesView.swift

    var body: some View {
        // A gesture to handle the closing of the story view.
        let closeGesture = DragGesture(minimumDistance: 10)
            .onChanged { value in
                if value.translation.height > 0 {
                    closingOffset = value.translation.height
                }
            }
            .onEnded { value in
                if value.predictedEndTranslation.height > 200 {
                    currentGroupStory = nil
                } else {
                    closingOffset = 0
                }
            }
            
        // Get the screen height to make the scale proportional.
        let screenHeight = UIScreen.main.bounds.height
        // Calculate the scale. It starts at 1.0 and decreases as you drag down.
        // We use max(0.8, ...) to prevent it from becoming too small, which looks better.
        let scale = max(0.8, 1 - (closingOffset / screenHeight))

        ZStack {
            // The gesture should be on the ZStack to avoid conflicts
            // and to allow interaction with the content inside.
            
            Color.black.ignoresSafeArea()

            TabView(selection: $viewModel.currentGroupIndex) {
                ForEach(Array(viewModel.storyGroups.enumerated()), id: \.element.id) { index, _ in
                    SingleStoryView(viewModel: viewModel)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.black)
            .ignoresSafeArea()
            .scaleEffect(scale) // Use the new, safe scale calculation.
            .offset(y: closingOffset)
            // It ensures corners are sharp initially and round off during the drag.
            .clipShape(RoundedRectangle(cornerRadius: closingOffset > 0 ? 20 : 0))
            .animation(.easeInOut(duration: 0.2), value: closingOffset) // Animate changes smoothly

        }
        .highPriorityGesture(closeGesture) // The gesture itself is on the parent ZStack.
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
    
    StoriesView(storyGroups: storyGroups, currentGroupStory: .constant(nil))
}

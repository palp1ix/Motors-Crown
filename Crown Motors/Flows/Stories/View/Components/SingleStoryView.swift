import SwiftUI

struct SingleStoryView: View {
    @ObservedObject var viewModel: StoriesViewModel

    var body: some View {
        let currentGroup = viewModel.storyGroups[viewModel.currentGroupIndex]
        
        ZStack {
            CustomVideoPlayer(viewModel: viewModel)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                ProgressViewStrips(viewModel: viewModel)
                    .padding(.top, 8)
                
                AuthorInfoView(author: currentGroup.author)
                    .padding(.horizontal)
                    .padding(.top, 15)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            NavigationTapOverlay(viewModel: viewModel)
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .gesture(holdToPauseGesture)
    }
    
    private var holdToPauseGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                viewModel.pausePlayback()
            }
            .onEnded { _ in
                viewModel.resumePlayback()
            }
    }
}


// MARK: - Helper Views

private struct ProgressViewStrips: View {
    @ObservedObject var viewModel: StoriesViewModel
    
    var body: some View {
        HStack(spacing: 4) {
            let storiesInGroup = viewModel.storyGroups[viewModel.currentGroupIndex].stories.count
            
            ForEach(0..<storiesInGroup, id: \.self) { index in
                let progress = calculateProgress(for: index)
                
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .background(Color.white.opacity(0.4))
                    .frame(height: 2.5)
                    .cornerRadius(1.25)
                    // Apply linear animation ONLY to the active story's progress.
                    // For all other bars (watched or upcoming), disable animation (.none)
                    // to ensure they snap to 0.0 or 1.0 instantly.
                    .animation(index == viewModel.currentStoryIndex ? .linear(duration: 0.2) : .none, value: progress)
            }
        }
        .padding(.horizontal)
    }
    
    private func calculateProgress(for index: Int) -> Double {
        if index < viewModel.currentStoryIndex {
            return 1.0 // Watched
        }
        if index == viewModel.currentStoryIndex {
            return viewModel.progress // Watching
        }
        return 0.0 // Not yet watched
    }
}

// AuthorInfoView and NavigationTapOverlay remain unchanged.
// ... (You can copy them from the previous response)

private struct AuthorInfoView: View {
    let author: StoryAuthor
    
    var body: some View {
        HStack(spacing: 12) {
            Image(author.imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .foregroundColor(.white.opacity(0.9))

            Text(author.name)
                .font(.headline)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 1)
            
            Spacer()
        }
    }
}

private struct NavigationTapOverlay: View {
    @ObservedObject var viewModel: StoriesViewModel

    var body: some View {
        HStack {
            // Tap areas for navigation
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.regressStory()
                }
            // A free space to allow tapping in the middle of the screen
            GeometryReader { geometry in
                Color.clear
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width / 3, height: geometry.size.height)
            }
            // Tap area for advancing the story
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.advanceStory()
                }
        }
    }
}

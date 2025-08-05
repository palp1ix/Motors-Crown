import Foundation
import AVKit
import Combine

class StoriesViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var storyGroups: [StoryGroup]
    @Published var currentGroupIndex: Int = 0
    @Published var currentStoryIndex: Int = 0
    @Published var player = AVPlayer()
    @Published var isLoading: Bool = true
    @Published var progress: Double = 0.0
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private var itemCancellables = Set<AnyCancellable>()
    private var timeObserver: Any?

    // MARK: - Initialization
    
    init(storyGroups: [StoryGroup], startGroupIndex: Int = 0) {
        self.storyGroups = storyGroups
        self.currentGroupIndex = startGroupIndex
        
        setupStateSubscribers()
        loadStory()
    }
    
    deinit {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
        }
    }
    
    // MARK: - Public Control Methods
    
    func advanceStory() {
        let storyCountInGroup = storyGroups[currentGroupIndex].stories.count
        
        if currentStoryIndex < storyCountInGroup - 1 {
            currentStoryIndex += 1
        } else {
            if currentGroupIndex < storyGroups.count - 1 {
                currentGroupIndex += 1
                currentStoryIndex = 0 // Reset to the first story of the next group
            } else {
                print("All stories finished.")
                player.pause()
            }
        }
    }
    
    func regressStory() {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
        } else {
            if currentGroupIndex > 0 {
                currentGroupIndex -= 1
                // Reset to the last story of the previous group
                currentStoryIndex = storyGroups[currentGroupIndex].stories.count - 1
            } else {
                print("Already at the very first story.")
            }
        }
    }
    
    func pausePlayback() {
        player.pause()
    }
    
    func resumePlayback() {
        player.play()
    }
    
    // MARK: - Private Logic
    
    private func loadStory() {
        guard currentGroupIndex < storyGroups.count &&
              currentStoryIndex < storyGroups[currentGroupIndex].stories.count else {
            // TODO: Make a dismiss action for the view.
            return
        }

        // 1. Immediately stop the player and clear the current item.
        // This prevents the player from trying to finish loading a previous, now irrelevant, story.
        player.replaceCurrentItem(with: nil)
        
        // 2. Cancel all subscriptions related to the *previous* item.
        itemCancellables.removeAll()
        
        // 3. Reset UI state.
        self.progress = 0.0
        self.isLoading = true
        
        // 4. Proceed with loading the new item.
        let currentStoryContent = storyGroups[currentGroupIndex].stories[currentStoryIndex].content
        
        guard let url = URL(string: currentStoryContent) else {
            print("Error: Invalid URL for story content: \(currentStoryContent)")
            self.isLoading = false
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        setupItemSubscribers(for: playerItem)
        
        player.replaceCurrentItem(with: playerItem)
        // Playback will automatically start once the item's status is .readyToPlay (handled in setupItemSubscribers)
    }
    
    private func setupStateSubscribers() {
        // This publisher now triggers ONLY when a unique combination
        // of group and story index appears.
        $currentGroupIndex
            .combineLatest($currentStoryIndex)
            .removeDuplicates { prev, current in
                // Only fire if both group and story index are the same as before.
                return prev.0 == current.0 && prev.1 == current.1
            }
            .sink { [weak self] (groupIndex, storyIndex) in
                // Now we have a single, reliable trigger to load the story.
                print("Loading story for group \(groupIndex), story \(storyIndex)")
                self?.loadStory()
            }
            .store(in: &cancellables)
            
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self, let duration = self.player.currentItem?.duration else { return }
            
            let totalSeconds = CMTimeGetSeconds(duration)
            if totalSeconds.isFinite && totalSeconds > 0 {
                let currentSeconds = CMTimeGetSeconds(time)
                
                // Clamp the value to the 0...1 range before assigning it.
                self.progress = min(1.0, max(0.0, currentSeconds / totalSeconds))
            }
        }
    }
    
    // This method sets up subscribers for the AVPlayerItem.
    private func setupItemSubscribers(for item: AVPlayerItem) {
        // Subscriber for when the item finishes playing.
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: item)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.advanceStory()
            }
            .store(in: &itemCancellables)
            
        // Subscriber for the item's status.
        item.publisher(for: \.status)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == .readyToPlay {
                    self?.isLoading = false
                    self?.player.play()
                } else if status == .failed {
                    print("Player item failed to load.")
                    self?.isLoading = false
                }
            }
            .store(in: &itemCancellables)
    }
}

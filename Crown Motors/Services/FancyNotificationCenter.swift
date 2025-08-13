import Combine
import Foundation

class FancyNotificationCenter: ObservableObject {
    // Singleton method
    static let shared = FancyNotificationCenter()
    /// Time to close notification
    public var timeToClose: TimeInterval = 3
    
    // Notification that shown now
    // Only one notification can be shown at one time
    @Published private(set) var currentNotification: Notification?
    // Notifications that waiting for showing
    private var notificationsStack: [Notification] = []
    // Set for publishers
    private var cancellables: Set<AnyCancellable> = []
    // Flag to prevent race condition
    private var isProcessingQueue = false
    
    private init() {
        $currentNotification
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] notification in
                self?.handleNotificationChange(notification)
            })
            .store(in: &cancellables)
    }
    
    private func handleNotificationChange(_ notification: Notification?) {
    // If notification is shown, start timer to hide it
        if notification != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeToClose) { [weak self] in
                self?.processNextNotification()
            }
        }
    }
    
    private func processNextNotification() {
        guard !isProcessingQueue else { return }
        isProcessingQueue = true
        
        // If there are notifications in queue, show next one
        if !notificationsStack.isEmpty {
            currentNotification = notificationsStack.removeFirst()
        } else {
            // Queue is empty, hide current notification
            currentNotification = nil
        }
        
        isProcessingQueue = false
    }
    
    deinit {
        // Dispose all subscriptions
        cancellables.removeAll()
    }
    
    public func create(notification: Notification) {
        // Check if now any notification showing
        if currentNotification == nil {
            currentNotification = notification
        } else {
            // Should wait
            notificationsStack.append(notification)
        }
    }
    
    // Method for force dismissing current notification
    public func dismissCurrent() {
        processNextNotification()
    }
}

import UIKit
import Combine

/// Container that managing lifecycle of notifications
/// Manipulating notification shown/deletion/expand etc.
class FancyNotificationContainer: UIView {
    // Notification center instance
    private let notificationCenter = FancyNotificationCenter.shared
    // Offset for expanding notification
    public let offsetForExpand: CGFloat = 50.0
    // Current notification view that shown now
    private var currentNotificationView: FancyNotificationView? = nil
    // Initial center point for notification view
    private var initialCenterPoint: CGPoint = .zero
    // Offset for closing notification
    public let offsetForClose: CGFloat = 20.0
    private var cancellables: Set<AnyCancellable> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        // Subscribe on notification changes
        notificationCenter.$currentNotification
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.handleNotificationChange(notification)
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Override hitTest to handle touches in notification area
    /// If notification is shown, we will pass touches to it
    /// If not, we will return nil to allow system to find another view
    /// - Parameters:
    ///   - point: Point in container coordinates
    ///   - event: Event that triggered hitTest
    /// - Returns: View that should handle touch, or nil if no view found
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // If no notification is shown, return nil
        guard let notificationView = currentNotificationView, notificationView.currentState != .hidden else {
            return nil
        }
        
        // Convert point to notification view coordinates
        let pointInNotification = notificationView.convert(point, from: self)
        // Check if point is inside notification view bounds
        if notificationView.bounds.contains(pointInNotification) {
            return notificationView.hitTest(pointInNotification, with: event)
        }
    
        // If point is outside notification view, return nil
        return nil
    }

    
    private func handleNotificationChange(_ notification: Notification?) {
        if notification != nil {
            // Show new notification
            print("Going for create notification")
            createNotification(notification!)
            showNotification()
        } else {
            // If notification expanded, we do not hide it immediately
            guard currentNotificationView?.currentState != .expanded else { return }
            // Hide current notification
            hideNotification()
        }
    }
    
    func createNotification(_ notification: Notification) {
        // First remove previous notification if exists
        if let existingView = currentNotificationView {
            existingView.removeFromSuperview()
            currentNotificationView = nil
        }
        
        // Create notification view
        print("Creating notification view")
        let notificationView = FancyNotificationView(notification: notification)
        // Create gesture for interact handling
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        notificationView.addGestureRecognizer(gesture)
        // Setup notification layout in self view
        print("Setup notification view layout")
        notificationView.setupLayout(in: self)
        currentNotificationView = notificationView
    }
    
    func showNotification() {
        guard let currentNotificationView = currentNotificationView else { return }
        
        print("Showing notification...")
         
        if currentNotificationView.currentState == .hidden {
            // Start state
            currentNotificationView.alpha = 0.0
            currentNotificationView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            self.layoutIfNeeded()
            currentNotificationView.bottomConstraint?.constant = -(window?.safeAreaInsets.bottom ?? 0) - 20
            
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.8,
                options: [.curveEaseOut],
                animations: {
                    self.layoutIfNeeded()
                    currentNotificationView.alpha = 1.0
                    currentNotificationView.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
                }
            ) { _ in
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    animations: {
                        currentNotificationView.transform = CGAffineTransform.identity
                    }
                ) { _ in
                    currentNotificationView.currentState = .collapsed
                    // Save initial center point after animation completes
                    self.initialCenterPoint = currentNotificationView.center
                    print("Notification showed and ready")
                }
            }
        }
    }
    
    func hideNotification() {
        guard let currentNotificationView = currentNotificationView else { return }
        print("Hiding notification...")
        
        if currentNotificationView.currentState != .hidden {
            self.layoutIfNeeded()
            // Change bottom constraint to hide notification
            currentNotificationView.bottomConstraint?.constant = currentNotificationView.collapsedHeight
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    currentNotificationView.alpha = 0.0
                    self.layoutIfNeeded()
                },
                completion: { _ in
                    currentNotificationView.currentState = .hidden
                    currentNotificationView.removeFromSuperview()
                    self.currentNotificationView = nil
                    print("Notification hidden and removed")
                }
            )
        }
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let notificationView = gesture.view as? FancyNotificationView else { return }
        guard notificationView.currentState != .hidden else { return }
        
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            // Save initial center point when gesture begins
            initialCenterPoint = notificationView.center

            
        case .changed:
            // Calculate new position with exponential resistance using pow()
            let newY: CGFloat
            let scaleY: CGFloat
            
            if translation.y < 0 {
                // Pulling up - exponential resistance (gets harder and harder)
                // Using power function to create diminishing returns
                let absTranslation = abs(translation.y)
                let maxPullDistance: CGFloat = 60.0 // Maximum possible pull distance
                
                // Exponential resistance formula: maxDistance * (1 - (1 - progress)^power)
                let progress = min(absTranslation / 200.0, 1.0) // Normalize input
                let powerValue: CGFloat = 3.0 // Higher = more resistance
                let resistedDistance = maxPullDistance * (1.0 - pow(1.0 - progress, powerValue))
                
                newY = initialCenterPoint.y - resistedDistance
                
                // Scale effect - slight stretch when pulling up
                let stretchProgress = resistedDistance / maxPullDistance
                scaleY = 1.0 + (stretchProgress * 0.08) // Max 8% stretch
                
            } else {
                // Pulling down - also exponential but allows more movement
                let maxPullDistance: CGFloat = 100.0
                let progress = min(translation.y / 150.0, 1.0)
                let powerValue: CGFloat = 2.5
                let resistedDistance = maxPullDistance * (1.0 - pow(1.0 - progress, powerValue))
                
                newY = initialCenterPoint.y + resistedDistance
                
                // Scale effect - compress then stretch
                if resistedDistance < 25 {
                    // Initial compression
                    scaleY = 1.0 - (resistedDistance / 25.0) * 0.03 // Max 3% compression
                } else {
                    // Then stretch
                    let stretchProgress = (resistedDistance - 25.0) / 75.0
                    scaleY = 0.97 + (stretchProgress * 0.06) // From compressed back to 1.03
                }
            }
            
            // Apply new position and scale
            notificationView.center = CGPoint(x: initialCenterPoint.x, y: newY)
            notificationView.transform = CGAffineTransform(scaleX: 1.0, y: max(scaleY, 0.94))
            
        case .ended, .cancelled:
            // Reset translation for next gesture
            gesture.setTranslation(.zero, in: self)
            
            // Determine action based on translation and velocity
            if translation.y > offsetForClose{
                if notificationView.currentState == .expanded {
                    // If expanded, collapse it
                    notificationView.collapse()
                }
                // Fast swipe down - close notification
                animateNotificationClose(notificationView)
            } else if translation.y < -offsetForExpand {
                
                if notificationView.currentState == .expanded {
                    animateNotificationReturn(notificationView)
                } else {
                    // Swipe up or fast swipe up - expand notification
                    animateNotificationExpand(notificationView)
                }
                
            } else {
                // Return to original position
                animateNotificationReturn(notificationView)
            }
            
        default:
            break
        }
    }
    
    private func animateNotificationReturn(_ notificationView: FancyNotificationView) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: {
                notificationView.center = self.initialCenterPoint
                notificationView.transform = CGAffineTransform.identity
            }
        )
    }
    
    private func animateNotificationExpand(_ notificationView: FancyNotificationView) {
            // First return to transform ro identity
            notificationView.transform = CGAffineTransform.identity
            // Then expand
            notificationView.expand()
            self.initialCenterPoint = notificationView.center
    }
    
    private func animateNotificationClose(_ notificationView: FancyNotificationView) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1.0,
            animations: {
                notificationView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                notificationView.alpha = 0.5
                // Move notification down and out of screen
                notificationView.center = CGPoint(
                    x: self.initialCenterPoint.x,
                    y: self.initialCenterPoint.y + 150
                )
            }
        ) { _ in
            // Dismiss through notification center
            FancyNotificationCenter.shared.dismissCurrent()
        }
    }
}

import UIKit

class FancyNotificationView: UIView {
    // Notification view state: expanded, collapsed, hidden
    public var currentState: NotificationState = .hidden
    // Notification model
    let notification: Notification
    // Constants
    public let collapsedHeight: CGFloat = 65
    // Constraint for animating the height of the notification view
    public var bottomConstraint: NSLayoutConstraint?
    // Height constraint modified during expand/collapse
    private var heightConstraint: NSLayoutConstraint?
    // Container constraints that change between states
    private var containerTopConstraint: NSLayoutConstraint?
    private var containerCenterYConstraint: NSLayoutConstraint?
    private var bodyLabelConstraints: [NSLayoutConstraint] = []
    
    // UI Elements
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        // Text stack view - should occupy most of the space
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.numberOfLines = 2 // Allow 2 lines to prevent truncation
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expandIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let glassEffectView: UIVisualEffectView = {
        let effect = UIGlassEffect(style: .clear)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    
    init(notification: Notification) {
        self.notification = notification
        super.init(frame: .zero)
        self.setupNotification()
        self.setupUI()
        self.configureContent()
    }
    
    required init(coder: NSCoder) {
        fatalError("No implementation")
    }
    
    private func setupNotification() {
        backgroundColor = notification.color.withAlphaComponent(0.9)
        layer.masksToBounds = true
    }
    
    private func setupUI() {
        addSubview(glassEffectView)
        // Add main container
        addSubview(containerStackView)
        
        // Setup text stack view
        textStackView.addArrangedSubview(titleLabel)
        
        // Add subtitle only if it exists
        if !notification.subtitle.isEmpty {
            textStackView.addArrangedSubview(subtitleLabel)
        }
        
        // Add subviews into container stack view
        containerStackView.addArrangedSubview(symbolImageView)
        containerStackView.addArrangedSubview(textStackView)
        containerStackView.addArrangedSubview(expandIndicatorView)
        
        // Add body label separately for expanded state
        addSubview(bodyLabel)
        bodyLabel.isHidden = true // Initially hidden in collapsed state
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Container stack view constraints - initially centered for collapsed state
        containerCenterYConstraint = containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        NSLayoutConstraint.activate([
            // Background glass effect view constraints
            glassEffectView.topAnchor.constraint(equalTo: topAnchor),
            glassEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            glassEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Container stack view constraints
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerCenterYConstraint!,
            
            // Symbol image view constraints
            symbolImageView.widthAnchor.constraint(equalToConstant: 24),
            symbolImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Expand indicator constraints
            expandIndicatorView.widthAnchor.constraint(equalToConstant: 4),
            expandIndicatorView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        // Set content priorities to avoid conflicts
        symbolImageView.setContentHuggingPriority(.required, for: .horizontal)
        expandIndicatorView.setContentHuggingPriority(.required, for: .horizontal)
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func configureContent() {
        // Configure title
        titleLabel.text = notification.title
        print("Title configured: '\(notification.title)'")
        
        // Configure subtitle
        if !notification.subtitle.isEmpty {
            subtitleLabel.text = notification.subtitle
            subtitleLabel.isHidden = false
            print("Subtitle configured: '\(notification.subtitle)'")
        } else {
            subtitleLabel.isHidden = true
            print("No subtitle")
        }
        
        // Configure symbol
        if !notification.symbol.isEmpty {
            symbolImageView.image = UIImage(systemName: notification.symbol)
            symbolImageView.isHidden = false
            print("Symbol configured: '\(notification.symbol)'")
        } else {
            symbolImageView.isHidden = true
            print("No symbol")
        }
        
        // Configure body (displayed only in expanded state)
        if !notification.body.isEmpty {
            bodyLabel.text = notification.body
            print("Body text configured: '\(notification.body.prefix(50))...' (length: \(notification.body.count))")
        } else {
            bodyLabel.text = nil
            print("No body text")
        }
        
        // Show expand indicator only if body text exists
        expandIndicatorView.isHidden = notification.body.isEmpty
        print("Expand indicator visible: \(!notification.body.isEmpty)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update corner radius based on current height
        layer.cornerRadius = min(bounds.height / 2, 25) // Maximum 25pt radius in expanded state
    }
    
    func setupLayout(in parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        // Setup constraints
        bottomConstraint = bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: collapsedHeight)
        heightConstraint = heightAnchor.constraint(equalToConstant: collapsedHeight)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 10),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -10),
            heightConstraint!,
            bottomConstraint!
        ])
    }
    
    // MARK: - State Management
    func expand() {
        guard currentState == .collapsed else { return }
        
        // Show body label if available
        if !notification.body.isEmpty {
            bodyLabel.isHidden = false
            
            // СНАЧАЛА вычисляем нужную высоту
            bodyLabel.text = notification.body // убеждаемся что текст установлен
            
            // Временно измеряем размеры без constraints
            let containerHeight = containerStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let maxWidth = bounds.width - 32 // с учетом горизонтальных отступов
            let bodyLabelSize = bodyLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
            let totalHeight = 16 + containerHeight + 10 + bodyLabelSize.height + 16
            
            print("Calculated heights - Container: \(containerHeight), Body: \(bodyLabelSize.height), Total: \(totalHeight)")
            
            // СНАЧАЛА обновляем высоту уведомления
            heightConstraint?.constant = totalHeight
            
            // Затем переключаем constraints для контейнера
            containerCenterYConstraint?.isActive = false
            
            if containerTopConstraint == nil {
                containerTopConstraint = containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16)
            }
            containerTopConstraint?.isActive = true
            
            // И только ПОСЛЕ изменения высоты добавляем body constraints
            bodyLabelConstraints = [
                bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                bodyLabel.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: 10),
                bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
            ]
            NSLayoutConstraint.activate(bodyLabelConstraints)
            
            // Анимируем изменения
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
                self.superview?.layoutIfNeeded()
            } completion: { _ in
                self.currentState = .expanded
                print("Expand animation completed. Current height: \(self.bounds.height)")
            }
            
        } else {
            // Если нет body текста
            containerCenterYConstraint?.isActive = false
            
            if containerTopConstraint == nil {
                containerTopConstraint = containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16)
            }
            containerTopConstraint?.isActive = true
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
                self.heightConstraint?.constant = self.collapsedHeight + 20
                self.superview?.layoutIfNeeded()
            } completion: { _ in
                self.currentState = .expanded
            }
        }
    }
    
    func collapse() {
        guard currentState == .expanded else { return }
        
        // Скрываем body label
        bodyLabel.isHidden = true
        
        // Деактивируем body label constraints
        NSLayoutConstraint.deactivate(bodyLabelConstraints)
        bodyLabelConstraints.removeAll()
        
        // Переключаемся обратно на centerY constraint
        containerTopConstraint?.isActive = false
        containerCenterYConstraint?.isActive = true
        
        // Анимируем возврат к collapsed состоянию
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.heightConstraint?.constant = self.collapsedHeight
            self.superview?.layoutIfNeeded()
            self.layoutIfNeeded()
        } completion: { _ in
            self.currentState = .collapsed
            print("Collapse animation completed. Current height: \(self.bounds.height)")
        }
    }
}

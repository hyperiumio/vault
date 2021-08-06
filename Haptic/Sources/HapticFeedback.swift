#if os(iOS)
import UIKit

public struct HapticFeedback {
    
    private let generator = UINotificationFeedbackGenerator()
    
    public func play(_ type: FeedbackType) {
        switch type {
        case .success:
            generator.notificationOccurred(.success)
        case .error:
            generator.notificationOccurred(.error)
        case .warning:
            generator.notificationOccurred(.warning)
        }
    }
    
}
#endif

#if os(macOS)
public struct HapticFeedback {
    
    public func play(_ type: FeedbackType) {}
    
}
#endif

public extension HapticFeedback {
    
    enum FeedbackType {
        
        case success
        case error
        case warning
        
    }
    
}

public extension HapticFeedback {
    
    static let shared = HapticFeedback()
    
}


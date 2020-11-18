#if os(macOS)
public class SuccessFeedbackGenerator {
    
    public init() {}
    
    public func prepare() {}
    
    public func play() {}
    
}
#endif

#if canImport(UIKit)
import UIKit

public class SuccessFeedbackGenerator {
    
    private let notificationGenerator: UINotificationFeedbackGenerator
    
    public init() {
        self.notificationGenerator = UINotificationFeedbackGenerator()
    }
    
    public func prepare() {
        notificationGenerator.prepare()
    }
    
    public func play() {
        notificationGenerator.notificationOccurred(.success)
    }
    
}
#endif

import CoreHaptics

public class ChangeFeedbackGenerator {
    
    private let engine: CHHapticEngine?
    private var player: CHHapticPatternPlayer?
    
    public init() {
        let engine = try? CHHapticEngine()
        engine?.resetHandler = {
            try? engine?.start()
        }
        
        self.engine = engine
    }
    
    public func start() {
        let parameters = [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        ]
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: parameters, relativeTime: CHHapticTimeImmediate)
        guard let pattern = try? CHHapticPattern(events: [event], parameters: []) else { return }
        
        player = try? engine?.makePlayer(with: pattern)
        engine?.start(completionHandler: nil)
    }
    
    public func stop() {
        player = nil
        engine?.stop(completionHandler: nil)
    }
    
    public func play() {
        try? player?.start(atTime: CHHapticTimeImmediate)
    }
    
}

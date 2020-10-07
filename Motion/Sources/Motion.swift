import Combine
import CoreMotion

public class Gyroscope {
    
    public var tiltDidChange: AnyPublisher<Tilt, Never> {
        tiltDidChangeSubject.eraseToAnyPublisher()
    }
    
    private let tiltDidChangeSubject = PassthroughSubject<Tilt, Never>()
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    private var startCount = 0
    private var referenceAttitude: CMAttitude?

    public func start() {
        guard motionManager.isDeviceMotionAvailable else { return }
        guard startCount == 0 else { return }
        
        startCount += 1
        
        let updateInterval = 1.0 / 60.0
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            guard let attitude = self.motionManager.deviceMotion?.attitude else { return }
            
            if self.referenceAttitude == nil {
                self.referenceAttitude = attitude
                return
            }
            
            if let referenceAttitude = self.referenceAttitude {
                attitude.multiply(byInverseOf: referenceAttitude)
            }

            let radiantUpperBound = Double.pi / 2
            var x = attitude.roll
            switch x {
            case radiantUpperBound.nextUp ... Double.pi:
                x = radiantUpperBound - (x - radiantUpperBound)
            case -Double.pi ..< -radiantUpperBound:
                x = -radiantUpperBound - (x + radiantUpperBound)
            default:
                break
            }
            x /= radiantUpperBound
            
            let y = attitude.pitch / (Double.pi / 2)
            let tilt = Tilt(x: x, y: y)
            
            self.tiltDidChangeSubject.send(tilt)
        }
    }
    
    public func stop() {
        guard startCount > 0 else{ return }
        
        startCount -= 1
        
        if startCount == 0 {
            timer?.invalidate()
            motionManager.stopDeviceMotionUpdates()
            timer = nil
            referenceAttitude = nil
        }
    }
    
}

extension Gyroscope {
    
    public static let shared = Gyroscope()
    
}

extension Gyroscope {
    
    public struct Tilt {
        
        public let x: Double
        public let y: Double
        
    }
    
}

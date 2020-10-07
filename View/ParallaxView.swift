import Motion
import SwiftUI

struct ParallaxView<Content>: View where Content: View {
    
    private let amplitude: CGFloat
    private let content: Content
    @State private var offsetX = 0.0 as CGFloat
    @State private var offsetY = 0.0 as CGFloat
    
    init(amplitude: Double, @ViewBuilder content: () -> Content) {
        self.amplitude = CGFloat(amplitude)
        self.content = content()
    }
    
    var body: some View {
        content
            .offset(x: offsetX, y: offsetY)
            .onAppear {
                Gyroscope.shared.start()
            }
            .onDisappear {
                Gyroscope.shared.stop()
            }
            .onReceive(Gyroscope.shared.tiltDidChange) { tilt in
                offsetX = CGFloat(tilt.x) * 20
                offsetY = CGFloat(tilt.y) * 20
            }
    }
    
}

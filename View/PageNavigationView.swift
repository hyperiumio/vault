import SwiftUI
#warning("Todo")
struct PageNavigationView<Content>: View where Content: View {
    
    private let title: LocalizedStringKey
    private let content: Content
    private let configuration: Configuration
    
    init(_ title: LocalizedStringKey, isEnabled: Bool, action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        self.configuration = .forward(isEnabled: isEnabled, action: action)
    }
    
    init(_ title: LocalizedStringKey, enabledIntensions: Set<PageNavigationIntention>, action: @escaping (PageNavigationIntention) -> Void, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        self.configuration = .forwardBack(enabledIntensions: enabledIntensions, action: action)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            switch configuration {
            case .forward(let isEnabled, let action):
                content
                
                Button(title, action: action)
                    .disabled(!isEnabled)
            case .forwardBack(let enabledIntensions, let action):
                HStack {
                    Button {
                        action(.backward)
                    } label: {
                        Image(systemName: .chevronLeft)
                            .imageScale(.large)
                    }
                    .disabled(!enabledIntensions.contains(.backward))
                    
                    Spacer()
                }
                
                content
                
                Button(title) {
                    action(.forward)
                }
                .disabled(!enabledIntensions.contains(.forward))
            }
        }
        .padding()
    }
    
}

enum PageNavigationIntention {
    
    case forward
    case backward
    
}

extension PageNavigationView {
    
    private enum Configuration {
        
        case forward(isEnabled: Bool, action: () -> Void)
        case forwardBack(enabledIntensions: Set<PageNavigationIntention>, action: (PageNavigationIntention) -> Void)
        
    }
    
    private struct NavigationButton: View {
        
        private let title: LocalizedStringKey
        private let imageName: String
        private let action: () -> Void
        
        init(_ title: LocalizedStringKey, imageName: String, action: @escaping () -> Void) {
            self.title = title
            self.imageName = imageName
            self.action = action
        }
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 5) {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    
                    Text(title)
                        .font(.headline)
                }
            }
            
            .foregroundColor(.accentColor)
            .buttonStyle(PlainButtonStyle())
        }
        
    }
    
}

#if DEBUG
struct PageNavigationViewProvider: PreviewProvider {
    
    static let state = ChoosePasswordStateStub()
    
    static var previews: some View {
        Group {
            PageNavigationView("Title", isEnabled: true) {} content: {
                Text("Content")
            }
            .preferredColorScheme(.light)
            
            PageNavigationView("Title", enabledIntensions: [.forward, .backward]) { _ in } content: {
                Text("Content")
            }
            .preferredColorScheme(.light)
            
            PageNavigationView("Title", isEnabled: true) {} content: {
                Text("Content")
            }
            .preferredColorScheme(.dark)
            
            PageNavigationView("Title", enabledIntensions: [.forward, .backward]) { _ in } content: {
                Text("Content")
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif

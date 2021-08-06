import Resource
import SwiftUI

struct SetupStepView<Content>: View where Content: View {
    
    private let image: String?
    private let title: String?
    private let description: String?
    private let content: Content?
    
    init(image: String? = nil, title: String? = nil, description: String? = nil, content: () -> Content) {
        self.image = image
        self.title = title
        self.description = description
        self.content = content()
    }
    
    var body: some View {
        VStack {
            if let image = image {
                Image(image)
            }
            
            if let title = title {
                Text(title)
                    .font(.title)
            }
            
            if let description = description {
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            
            content
        }
        .multilineTextAlignment(.center)
    }
    
}

extension SetupStepView where Content == EmptyView {
    
    init(image: String? = nil, title: String? = nil, description: String? = nil) {
        self.image = image
        self.title = title
        self.description = description
        self.content = EmptyView()
    }
    
}

#if DEBUG
struct SetupStepViewPreview: PreviewProvider {
    
    static var previews: some View {
        SetupStepView(image: "Placeholder", title: "foo", description: "bar") {
            Text("baz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        SetupStepView(image: "Placeholder", title: "foo", description: "bar") {
            Text("baz")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif

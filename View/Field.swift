import SwiftUI

struct Field<Title, Content>: View where Title: View, Content: View {
    
    private let title: Title
    private let content: Content
    
    init(@ViewBuilder title: () -> Title, @ViewBuilder content: () -> Content) {
        self.title = title()
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            title
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            content
        }
    }
    
}

extension Field where Title == Text {

    init(_ titleKey: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.title = Text(titleKey)
        self.content = content()
    }

    init<S>(_ title: S,  @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.title = Text(title)
        self.content = content()
    }
    
}

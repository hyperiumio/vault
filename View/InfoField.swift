import SwiftUI

struct InfoField<Title, Value>: View where Title: View, Value: View {
    
    private let title: Title
    private let value: Value
    
    init(@ViewBuilder title: () -> Title, @ViewBuilder value: () -> Value) {
        self.title = title()
        self.value = value()
    }
    
    var body: some View {
        HStack {
            title
            
            Spacer()
            
            value
                .foregroundStyle(.secondary)
        }
    }
    
}

extension InfoField where Title == Text, Value == Text {
    
    init(_ title: LocalizedStringKey, value: String) {
        self.title = Text(title)
        self.value = Text(value)
    }
    
}

#if DEBUG
struct InfoFieldPreview: PreviewProvider {
    
    static var previews: some View {
        InfoField {
            Text("foo")
        } value: {
            Text("bar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        InfoField {
            Text("foo")
        } value: {
            Text("bar")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif

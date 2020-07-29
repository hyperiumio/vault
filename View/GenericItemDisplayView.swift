import Localization
import SwiftUI

struct GenericItemDisplayView<Model>: View where Model: GenericItemDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Section {
            SecureItemDisplayField(title: model.fieldName, content: model.fieldValue)
                .onTapGesture(perform: model.copyFieldValueToPasteboard)
        }
    }
    
}

#if DEBUG
class GenericItemDisplayModelStub: GenericItemDisplayModelRepresentable {
    
    var fieldName = "Foo"
    var fieldValue = "Bar"
    
    func copyFieldValueToPasteboard() {}
    
}

struct GenericItemDisplayViewProvider: PreviewProvider {
    
    static let model = GenericItemDisplayModelStub()
    
    #if os(macOS)
    static var previews: some View {
        List {
            GenericItemDisplayView(model: model)
        }
    }
    #endif
    
    #if os(iOS)
    static var previews: some View {
        List {
            GenericItemDisplayView(model: model)
        }
        .listStyle(GroupedListStyle())
    }
    #endif
    
}
#endif

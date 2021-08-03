import Model
import Resource
import SwiftUI

struct SelectItemTypeView: View {
    
    private let action: (SecureItemType) -> Void
    
    init(action: @escaping (SecureItemType) -> Void) {
        self.action = action
    }
    
    
    var body: some View {
        Group {
            Button {
                action(.login)
            } label: {
                SecureItemTypeView(.login)
            }

            Button {
                action(.password)
            } label: {
                SecureItemTypeView(.password)
            }
            
            Button {
                action(.wifi)
            } label: {
                SecureItemTypeView(.wifi)
            }
            
            Button {
                action(.note)
            } label: {
                SecureItemTypeView(.note)
            }
            
            Button {
                action(.bankCard)
            } label: {
                SecureItemTypeView(.bankCard)
            }
            
            Button {
                action(.bankAccount)
            } label: {
                SecureItemTypeView(.bankAccount)
            }
            
            Button {
                action(.file)
            } label: {
                SecureItemTypeView(.file)
            }
            
            Button {
                action(.custom)
            } label: {
                SecureItemTypeView(.custom)
            }
        }
        .labelStyle(.titleAndIcon)
    }
    
}

#if DEBUG
struct SelectItemTypeViewPreview: PreviewProvider {
    
    static var previews: some View {
        SelectItemTypeView { itemType in
            print(itemType)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        SelectItemTypeView { itemType in
            print(itemType)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif

import SwiftUI

extension Section where Parent == EmptyView, Content: View, Footer: View {

    init(@ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        self.init(footer: footer(), content: content)
    }
}

extension Section where Parent: View, Content: View, Footer == EmptyView {

    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent) {
        self.init(header: header(), content: content)
    }
    
}

extension Section where Parent: View, Content: View, Footer: View {
    
    init(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> Parent, @ViewBuilder footer: () -> Footer) {
        self.init(header: header(), footer: footer(), content: content)
    }
    
}

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        List {
            Section {
                Field(.system, value: UIDevice.current.systemName)
                
                if let version = Info.version {
                    Field(.version, value: version)
                }
                
                if let build = Info.build {
                    Field(.build, value: build)
                }
            } header: {
                HStack {
                    Spacer()
                    
                    Image(ImageAsset.about.name)
                        .padding()
                    
                    Spacer()
                }

            }

        }
        .navigationTitle(.about)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

private extension AboutView {
    
    struct Field: View {
        
        private let title: LocalizedStringKey
        private let value: String
        
        init(_ title: LocalizedStringKey, value: String) {
            self.title = title
            self.value = value
        }
        
        var body: some View {
            HStack {
                Text(title)
                
                Spacer()
                
                Text(value)
                    .foregroundStyle(.secondary)
            }
        }
        
    }
    
}

#if DEBUG
struct AboutViewPreview: PreviewProvider {
    
    static var previews: some View {
        AboutView()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        AboutView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        List {
            Section {
                InfoField(.system, value: UIDevice.current.systemName)
                
                if let version = Info.version {
                    InfoField(.version, value: version)
                }
                
                if let build = Info.build {
                    InfoField(.build, value: build)
                }
            } header: {
                VStack(spacing: 10) {
                    Image(ImageAsset.about.name)
                    
                    if let appName = Info.appName {
                        Text(appName)
                            .textCase(.none)
                            .foregroundColor(.primary)
                            .font(.headline)
                    }
                    
                    Text(.copyright)
                        .textCase(.none)
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(.about)
        .navigationBarTitleDisplayMode(.inline)
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

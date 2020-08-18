import Localization
import SwiftUI

struct VaultItemFooter: View {
    
    let created: Date
    let modified: Date
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .custom, spacing: 4) {
                HStack(alignment: .center) {
                    Text(LocalizedString.created)
                        .fontWeight(.semibold)
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                        .alignmentGuide(.custom) { dimension in
                            dimension[HorizontalAlignment.trailing]
                        }
                        
                    Text(created, formatter: dateFormatter)
                }
                
                HStack {
                    Text(LocalizedString.modified)
                        .fontWeight(.semibold)
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                        .alignmentGuide(.custom) { dimension in
                            dimension[HorizontalAlignment.trailing]
                        }
                    
                    Text(created, formatter: dateFormatter)
                }
            }
            .font(.caption)
            
            Spacer()
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
}

private extension HorizontalAlignment {
    
    struct CustomAlignment: AlignmentID {
        
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
        
    }

    static let custom = HorizontalAlignment(CustomAlignment.self)
}

#if DEBUG
struct VaultItemFooterPreviewProvider: PreviewProvider {
    
    static let created = Date()
    static let modified = Date()
    
    static var previews: some View {
        VaultItemFooter(created: created, modified: modified)
    }
    
}
#endif

import Localization
import SwiftUI

struct VaultItemFooter: View {
    
    private let created: Date?
    private let modified: Date?
    
    init(created: Date?, modified: Date?) {
        self.created = created
        self.modified = modified
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .custom, spacing: 4) {
                if let created = created {
                    DateLabel(LocalizedString.created, date: created)
                }

                if let modified = modified {
                    DateLabel(LocalizedString.modified, date: modified)
                }
            }
            .font(.footnote)
            .foregroundColor(.secondaryLabel)
            
            Spacer()
        }
        .padding(.vertical)
    }
    
}

private struct DateLabel: View {
    
    private let text: String
    private let date: Date
    
    init(_ text: String, date: Date) {
        self.text = text
        self.date = date
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(text)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .alignmentGuide(.custom) { dimension in
                    dimension[HorizontalAlignment.trailing]
                }
                
            Text(date, formatter: dateFormatter)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
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

#if os(iOS) && DEBUG
struct VaultItemFooterPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            VaultItemFooter(created: .distantPast, modified: .distantFuture)
                .preferredColorScheme(.light)
            
            VaultItemFooter(created: .distantPast, modified: .distantFuture)
                .preferredColorScheme(.dark)

        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif

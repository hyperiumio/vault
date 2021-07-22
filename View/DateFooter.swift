import Resource
import SwiftUI

struct DateFooter: View {
    
    private let created: Date?
    private let modified: Date?
    
    init(created: Date?, modified: Date?) {
        self.created = created
        self.modified = modified
    }
    
    var body: some View {
        VStack(alignment: .title, spacing: 4) {
            if let created = created {
                DateLabel(Localized.created, date: created)
            }

            if let modified = modified {
                DateLabel(Localized.modified, date: modified)
            }
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
}

private extension DateFooter {
    
    struct DateLabel: View {
        
        private let text: String
        private let date: Date
        
        init(_ text: String, date: Date) {
            self.text = text
            self.date = date
        }
        
        var body: some View {
            HStack {
                Text(text)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .alignmentGuide(.title) { dimension in
                        dimension[HorizontalAlignment.trailing]
                    }
                   
                Text(date, format: Date.FormatStyle(date: .abbreviated))
            }
        }
        
    }
    
}

private extension HorizontalAlignment {
    
    struct TitleAlignment: AlignmentID {
        
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
        
    }

    static let title = Self(TitleAlignment.self)
    
}

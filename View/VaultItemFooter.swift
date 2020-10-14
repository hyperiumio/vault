import Localization
import SwiftUI

struct VaultItemFooter: View {
    
    let created: Date?
    let modified: Date?
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .custom, spacing: 4) {
                if let created = created {
                    HStack(alignment: .center) {
                        Text(LocalizedString.created)
                            .fontWeight(.semibold)
                            .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                            .alignmentGuide(.custom) { dimension in
                                dimension[HorizontalAlignment.trailing]
                            }
                            
                        Text(created, formatter: dateFormatter)
                    }
                }

                if let modified = modified {
                    HStack {
                        Text(LocalizedString.modified)
                            .fontWeight(.semibold)
                            .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                            .alignmentGuide(.custom) { dimension in
                                dimension[HorizontalAlignment.trailing]
                            }
                        
                        Text(modified, formatter: dateFormatter)
                    }
                }
            }
            .font(.footnote)
            .foregroundColor(.secondaryLabel)
            
            Spacer()
        }
        .padding(.vertical)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
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

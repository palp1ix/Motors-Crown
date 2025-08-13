import SwiftUI

struct PriceParam: View {
    let title: String
    let value: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(CFont.regular(16))
                .foregroundStyle(Theme.secondaryText)
            
            // Use formatted price
            Text(value, format: .currency(code: "USD"))
                .lineLimit(1)
                .truncationMode(.tail)
                .font(CFont.bold(30))
                .foregroundColor(Theme.primaryText)
        }
    }
}

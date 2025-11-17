import Foundation
import SwiftUI


struct FilterButton: View {
    let title: String
    var color: Color = .orange
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("PeppaBold", size: 15))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(isSelected ? color : Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color, lineWidth: 2)
                )
        }
    }
}


#Preview {
    EncyclopediaView(onBack: {})
}
